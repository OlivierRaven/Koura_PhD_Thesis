-- table-borders.lua
-- Inject \hline between every body row of LaTeX longtable output.
--
-- Also fixes a pandoc.write quirk where the longtable column specification
-- is emitted AFTER \caption{...}\tabularnewline instead of immediately after
-- \begin{longtable}.  On Windows, pandoc.write uses \r\n line endings, so we
-- strip \r before any comparisons.

local function split_lines(s)
  local out = {}
  for line in (s .. "\n"):gmatch("([^\n]*)\n") do
    -- Strip Windows carriage-return so string comparisons are reliable
    out[#out + 1] = line:gsub("\r$", "")
  end
  return out
end

-- Detect bare \begin{longtable} (no column spec on the same line) and move
-- the []{cols} block from after the \caption back to where LaTeX expects it.
local function fix_colspec_order(lines)
  local out = {}
  local i = 1
  while i <= #lines do
    -- Match \begin{longtable} alone on the line (trailing whitespace OK)
    if lines[i]:match("^\\begin{longtable}%s*$") then
      local j = i + 1
      local cap = {}
      -- Check whether next content is \caption (wrong ordering)
      if j <= #lines and lines[j]:match("^\\caption") then
        -- Collect caption lines up to and including the \tabularnewline
        while j <= #lines do
          cap[#cap + 1] = lines[j]
          if lines[j]:match("\\tabularnewline%s*$") then
            j = j + 1
            break
          end
          j = j + 1
        end
        -- Collect the column-spec block starting with []{  (any opt-arg)
        if j <= #lines and lines[j]:match("^%[.-%]%{") then
          local colspec = {}
          local depth = 0
          while j <= #lines do
            local ln = lines[j]
            colspec[#colspec + 1] = ln
            for c in ln:gmatch(".") do
              if     c == "{" then depth = depth + 1
              elseif c == "}" then depth = depth - 1 end
            end
            j = j + 1
            if depth <= 0 then break end
          end
          -- Emit: \begin{longtable}<colspec[1]>, rest of colspec, then caption
          out[#out + 1] = "\\begin{longtable}" .. colspec[1]
          for k = 2, #colspec do out[#out + 1] = colspec[k] end
          for _, cl in ipairs(cap) do out[#out + 1] = cl end
          i = j
        else
          -- No column spec found after caption — emit unchanged and move on
          out[#out + 1] = lines[i]
          for _, cl in ipairs(cap) do out[#out + 1] = cl end
          i = j
        end
      else
        -- Next line is NOT \caption — pass through unchanged
        out[#out + 1] = lines[i]
        i = i + 1
      end
    else
      out[#out + 1] = lines[i]
      i = i + 1
    end
  end
  return out
end

function Table(tbl)
  if not FORMAT:match("latex") then return tbl end

  local latex = pandoc.write(pandoc.Pandoc({tbl}), "latex")

  local lines = split_lines(latex)
  lines = fix_colspec_order(lines)

  -- Inject \hline after each body row
  local in_body = false
  local result  = {}
  for _, line in ipairs(lines) do
    if line:match("\\bottomrule") or line:match("\\end{longtable}") or
       line:match("\\end{tabular}") then
      in_body = false
    end
    result[#result + 1] = line
    if line:match("\\midrule") or line:match("\\endhead") then
      in_body = true
    elseif in_body and line:match("\\\\%s*$") then
      result[#result + 1] = "\\hline"
    end
  end

  return pandoc.RawBlock("latex", table.concat(result, "\n"))
end
