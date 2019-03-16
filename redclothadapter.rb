require 'redcloth' if ENV['REDCLOTH']

module RedClothAdapter

  def to_html_line_redcloth(line)
    return RedCloth.new(line).to_html
  end
  def to_html_array_redcloth
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
        html_line = to_html_line_redcloth(section)
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
      if line.start_with_bullet_or_number?
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
  def start_with_bullet_or_number?
    start_with_any? ['*','#']
  end
end
