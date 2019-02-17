class MyMarkdownSubset
  PATTERN_BULLET = '\*'
  NESTED_PATTERN_BULLET = '\*\*'
  PATTERN_NUMBERSIGN = '#'
  NESTED_PATTERN_NUMBERSIGN = '##'

  def initialize(line)
    @line = line 
  end
  def to_html
    result = to_href(@line)
    result = to_bold_or_italics(result)
    result = to_heading(result)
    if bullet_or_numbersign?(result)
      return to_listitem(result)
    end
    return "<p>#{result}</p>"
  end
  def to_href(text)
    result = text
    # note: below only works if space before and after "link":linkurl
    if text =~ /(?<before>.*)"(?<linkname>.*)":(?<linkurl>\S+)(?<after>.*)/
      before = $~[:before]
      linkname = $~[:linkname]
      linkurl = $~[:linkurl]
      after = $~[:after]
      result = "#{before}\s<a href=\"#{linkurl}\">#{linkname}</a>#{after}"
    end
    result
  end
  def bullet_or_numbersign?(text)
    return true if text =~ /#{PATTERN_BULLET}/
    return true if text =~ /#{PATTERN_NUMBERSIGN}/
    return false
  end
  def to_bold_or_italics(text)
    result = text
    if text =~ /b\./
      result = "<b>#{$~.post_match}</b>"
    elsif text =~ /i\./
      result = "<i>#{$~.post_match}</i>"
    end
    result
  end
  def to_heading(text)
    result = text
    if text =~ /h1\./
      result = "<h1>#{$~.post_match}</h1>"
    elsif text =~ /h2\./
      result = "<h2>#{$~.post_match}</h2>"
    elsif text =~ /h3\./
      result = "<h3>#{$~.post_match}</h3>"
    elsif text =~ /h4\./
      result = "<h4>#{$~.post_match}</h4>"
    end
    result
  end
  def to_listitem(textlines)
    lines = textlines.split(/\n/)
    result = ""
    listitems = Hash.new
    last_itemtext = nil
  
    # default is to look for bullet points
    pattern = PATTERN_BULLET
    nested_pattern = NESTED_PATTERN_BULLET
    list_type_tag_begin = "<ul>"
    list_type_tag_end = "</ul>"

    if textlines =~ /#{PATTERN_NUMBERSIGN}/
      pattern = PATTERN_NUMBERSIGN
      nested_pattern = NESTED_PATTERN_NUMBERSIGN
      list_type_tag_begin = "<ol>"
      list_type_tag_end = "</ol>"
    end
  
    lines.each do |line|
      if line =~ /#{nested_pattern}/
        # here we only handle 1 level nesting of bullets
        nested_items = listitems[last_itemtext]
        nested_items << $~.post_match
      elsif line =~ /#{pattern}/
        last_itemtext = $~.post_match 
        # if same bullet point text is repeated, this will clobber into only one
        listitems[last_itemtext] = []
      end
    end
  
    if !listitems.empty?
      result = "#{list_type_tag_begin}\n"
      listitems.each do |item,nested_items|
        result = result + "  <li>#{to_href(item)}</li>\n"
        if nested_items and !nested_items.empty?
          result = result + "  #{list_type_tag_begin}\n"
          nested_items.each do |nested_item|
            result = result + "    <li>#{to_href(nested_item)}</li>\n"
          end
          result = result + "  #{list_type_tag_end}\n"
        end
      end
      result = result + "#{list_type_tag_end}\n"
    end
    result
  end
end
