module MyMarkdownSubset

  PATTERN_BULLET = '^\* '
  NESTED_PATTERN_BULLET = '^\*\* '
  PATTERN_NUMBERSIGN = '^# '
  NESTED_PATTERN_NUMBERSIGN = '^## '

  class MyMarkdown
    # adding extra space afterwards so that format is different from *text* for <strong> tag
    # added extra space after # also, just for consistency
  
    def initialize(line, is_list_item)
      @line = line 
      @is_list_item = is_list_item     
    end
    def to_html
      if @line == ''
        return "<br/>"
      end
      result = to_href(@line)
      result = to_bold_or_italics(result)
      result = to_strong(result)
      if @is_list_item
        result = to_listitem(result)
      elsif is_heading?(result)
        result = to_heading(result)
      else
        result = to_p(result)
      end
      result
    end
    def to_href(text)
      result = text
      if text =~ /(?<before>.*)"(?<linkname>.*)":(?<linkurl>\S+)(?<after>.*)/
        before = $~[:before]
        linkname = $~[:linkname]
        linkurl = $~[:linkurl]
        after = $~[:after]
        result = "#{before}<a href=\"#{linkurl}\">#{linkname}</a>#{after}"
      end
      result
    end
    def to_bold_or_italics(text)
      result = text
      if text =~ /^b\./
        result = "<b>#{$~.post_match}</b>"
      elsif text =~ /^i\./
        result = "<i>#{$~.post_match}</i>"
      end
      result
    end
    def to_p(text)
      "<p>#{text}</p>"
    end
    def to_listitem(text)
      puts "text: #{text}"
      if text =~ /#{NESTED_PATTERN_BULLET}/
        text = $~.post_match
      elsif text =~ /#{PATTERN_BULLET}/
        text = $~.post_match
      elsif text =~ /#{NESTED_PATTERN_NUMBERSIGN}/
        text = $~.post_match
      elsif text =~ /#{PATTERN_NUMBERSIGN}/
        text = $~.post_match
      end
      return "<li>#{text}</li>"
    end
    def is_heading?(text)
      return true if text =~ /h1\./
      return true if text =~ /h2\./
      return true if text =~ /h3\./
      return true if text =~ /h4\./
      return false
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
    def to_strong(text)
      result = text
      if text =~ /(?<before>.*)\*(?<strong_text>.+)\*(?<after>.*)/
        before = $~[:before]
        strong_text = $~[:strong_text]
        puts "strong_text:(#{strong_text})"
        after = $~[:after]
        result = "#{before}<strong>#{strong_text}</strong>#{after}"
      end
      result
    end
  end

  class HTMLList
    attr_accessor :list_type,:list_level,:tag_begin,:tag_end
  
    def initialize(text)
      if text =~ /#{NESTED_PATTERN_BULLET}/
        @list_type = 'BULLET'
        @list_level = 2
        @tag_begin = "<ul>"
        @tag_end = "</ul>"
      elsif text =~ /#{PATTERN_BULLET}/
        @list_type = 'BULLET'
        @list_level = 1
        @tag_begin = "<ul>"
        @tag_end = "</ul>"
      elsif text =~ /#{NESTED_PATTERN_NUMBERSIGN}/
        @list_type = 'NUMBER'
        @list_level = 2
        @tag_begin = "<ol>"
        @tag_end = "</ol>"
      elsif text =~ /#{PATTERN_NUMBERSIGN}/
        @list_type = 'NUMBER'
        @list_level = 1
        @tag_begin = "<ol>"
        @tag_end = "</ol>"
      else
        @list_type = 'NONE'
      end
    end
    def to_s
      "#{@list_type} L#{@list_level}"
    end
  end

end
