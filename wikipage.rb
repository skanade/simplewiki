require 'mymarkdownsubset'
require 'redclothadapter'

class WikiPage
  attr_accessor :content
  attr_reader :page_name,:mtime 

  include MyMarkdownSubset
  include RedClothAdapter

  def initialize(page_name, *args)
    @page_name = page_name
    if args
      @mtime = args[0]
    end
  end
  def get_text_file_path
    file_name = @page_name + '.txt'
    File.join('text', file_name)
  end
  def readlines(text_file_path)
    File.readlines(text_file_path)
  end
  def to_html_line(line, is_list_item)
    return MyMarkdown.new(line, is_list_item).to_html
  end
  def to_html_array
    if ENV['REDCLOTH']
      to_html_array_redcloth
    else
      to_html_array_my_markdown
    end
  end
  def to_html_array_my_markdown
    text_file_path = get_text_file_path
    file_lines = readlines(text_file_path)

    result = []
    list_level = 0
    in_pre_section = false
    last_html_list = nil
    last_line = nil
    file_lines.each do |line|
      line.chomp!
      if line == ''
        result << to_html_line(line, false)
      elsif line.start_with?('</pre>')
        in_pre_section = false
        result << line
      elsif in_pre_section
        result << line
      elsif line.start_with?('<pre>')
        in_pre_section = true
        result << line
      else
        html_list = HTMLList.new(line)
        #puts "html_list #{html_list}"
        if html_list.list_type == 'NONE'
          if list_level > 0
            list_level.downto(1) do
              result << "#{last_html_list.tag_end}\n"
            end
            list_level = 0
          end
          result << to_html_line(line, false)
        elsif html_list.list_type == 'BULLET' or html_list.list_type == 'NUMBER'
          if html_list.list_level != list_level
            if html_list.list_level > list_level
              result << "#{html_list.tag_begin}\n"
            else
              result << "#{html_list.tag_end}\n"
            end
            list_level = html_list.list_level
          end
          result << "#{to_html_line(line, true)}\n"
        end
        last_html_list = html_list
      end
      last_line = line
    end
    result
  end

  def as_string
    text_file_path = get_text_file_path
    if File.exist?(text_file_path) 
      file_content = readlines(text_file_path)
      #puts "*** read from #{text_file_path}"
      #puts file_content
      result = ""
      file_content.each do |line|
        result << line
      end
      result
    else
      ""
    end
  end
  def save
    text_file_path = get_text_file_path
    File.delete(text_file_path) if File.exist?(text_file_path) 
    File.open(text_file_path, 'w') do |file|
      file.puts @content
    end
  end
  def search_for_text(text)
    text_file_path = get_text_file_path
    file_content = readlines(text_file_path)
    result = []
    #puts "*** search in #{text_file_path} ***"
    file_content.each do |line|
      #puts "    #{line}"
      if line =~ /#{text}/i
        result << line
      end
    end
    #puts "  * result has: #{result.size}"
    result
  end
  def to_s
    "(#{@page_name}) : mtime: #{@mtime}"
  end
end

