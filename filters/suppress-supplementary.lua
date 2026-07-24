-- Removes any Div with class "supplementary" from the document.
-- Used in the full thesis render so supplementary sections are
-- suppressed at their chapter position and collected in appendices instead.
function Div(el)
  if el.classes:includes("supplementary") then
    return {}
  end
end
