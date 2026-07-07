-- Removes {.chapter-only} divs in HTML and DOCX output.
-- Used in the full thesis _quarto.yml so journal-specific sections
-- (funding, author contributions, declarations, etc.) are hidden from
-- the combined thesis but remain visible in standalone chapter renders.
function Div(el)
  if el.classes:includes("chapter-only") then
    if FORMAT:match("html") or FORMAT:match("docx") then
      return {}
    end
  end
end
