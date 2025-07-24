function Header(el)
    function escape_html(s)
      return s
        :gsub("&", "&amp;")
        :gsub("<", "&lt;")
        :gsub(">", "&gt;")
        :gsub('"', "&quot;")
        :gsub("'", "&apos;")
    end
    local id = el.identifier
    if id == "" then return nil end  -- skip headers without IDs
    -- Build the <a> element
    local link = pandoc.RawInline('html', string.format(
        '<a href="%s" class="headerlink" title="%s" data-pjax-state=""></a>',
        escape_html("#"..id), escape_html(pandoc.utils.stringify(el.content))
    ))

    -- Insert the link before the content
    table.insert(el.content, 1, link)
    return el
end
