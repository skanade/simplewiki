require 'redcloth' if ENV['REDCLOTH']
require 'mymarkdownsubset'

class WikiPage
  attr_accessor :content
  attr_reader :page_name,:mtime 

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
  def to_html_line(line)
    if ENV['REDCLOTH']
      return RedCloth.new(line).to_html
    else
      return MyMarkdownSubset.new(line).to_html
    end
  end
  def to_html_array
    text_file_path = get_text_file_path
    file_content = readlines(text_file_path)
    sections = to_redcloth_sections(file_content)
    result = []
    in_pre_section = false    
    sections.each do |section|
      if section.start_with?('<pre>')
        html_line = section
        in_pre_section = true
      elsif section.start_with?('</pre>')
        html_line = section
        in_pre_section = false
      elsif in_pre_section
        html_line = section
      else
        html_line = to_html_line(section)
      end
      result << html_line
    end
    result 
  end
  def to_redcloth_sections(lines)
    result = []
    section = ""
    in_section = false
    
    lines.each do |line|
      line.chomp!
      if line.start_with_redcloth_section?
        section += "#{line}\n"
        #puts "section: #{section}"
        in_section = true
      else
        if in_section
          result << section.dup
          in_section = false
          section = ""
        end
        result << line
      end
    end
    if in_section
      result << section
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

class String
  def underscore_for_space
    result = gsub(' ','_')
  end
  def start_with_any?(list)
    list.each do |key|
      return true if start_with?(key)
    end
    return false
  end
  def start_with_redcloth_section?
    start_with_any? ['*','#']
  end
end
