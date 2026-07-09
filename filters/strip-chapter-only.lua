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

-- For PDF (LaTeX) output: strip chapter-level YAML fields (title, author,
-- abstract, date, etc.) so Quarto does not auto-render a title block
-- BEFORE the body content. Each research chapter's divider block (full-bleed
-- cover photo + sand page) must come first; the chapter heading (#) lives in
-- the body, after the divider.
function Meta(meta)
  if FORMAT:match("latex") then
    meta.title    = nil
    meta.subtitle = nil
    meta.author   = nil
    meta.abstract = nil
    meta.date     = nil
    meta.keywords = nil
    meta.funding  = nil
    meta.citation = nil
  end
  return meta
end
