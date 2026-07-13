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

-- Strip chapter-level YAML fields (title, author, abstract, date, etc.) so
-- Quarto does not auto-render a merged/broken title block. Research chapters
-- included via {{< include >}} accumulate their YAML into the document
-- metadata; without stripping, the last chapter's title overwrites the thesis
-- title and all corresponding:true author fields render as "true".
--
-- For PDF: clear everything — the chapter cover pages live in the body.
-- For HTML: restore the real thesis title from the preserved `thesis-title`
-- field (which no chapter file sets, so it survives include-merging).
function Meta(meta)
  local function strip_chapter_fields(m)
    m.subtitle = nil
    m.author   = nil
    m.abstract = nil
    m.date     = nil
    m.keywords = nil
    m.funding  = nil
    m.citation = nil
    return m
  end
  if FORMAT:match("latex") then
    meta.title = nil
    meta = strip_chapter_fields(meta)
  elseif FORMAT:match("html") then
    if meta["thesis-title"] then
      meta.title = meta["thesis-title"]
    end
    meta["title-block-style"] = pandoc.MetaString("none")
    meta = strip_chapter_fields(meta)
  end
  return meta
end
