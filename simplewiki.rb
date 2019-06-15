require_relative 'wikipage'
require_relative 'wikiconfig'

class SimpleWiki
  def initialize
    @config = WikiConfig.new
  end
  def get_text_file_paths
    text_file_paths = Dir.glob('text/*.txt')
  end
  def saved_page_names
    text_file_paths = get_text_file_paths
    #puts text_file_paths
    saved_pages = []
    text_file_paths.each do |text_file_path|
      page_name = page_name(text_file_path)
      saved_pages << page_name
    end
    saved_pages
  end
  def search_for_text(text)
    #puts "--- search_for_text (#{text})"
    text_file_paths = get_text_file_paths    
    result = Hash.new
    text_file_paths.each do |text_file_path|
      page_name = page_name(text_file_path)
      page = WikiPage.new(page_name)
      matching_lines = page.search_for_text(text)
      next if matching_lines.empty?
      result[page_name] = matching_lines
    end
    #puts "+++++ search_for_text (#{text}) result has #{result.size} pages with matches +++++"
    result
  end
  def page_name(text_file_path)
    File.basename(text_file_path, '.txt')     
  end
  def last_page_name
    text_file_paths = get_text_file_paths
    last_mtime = nil
    last_page = nil
    text_file_paths.each do |text_file_path|
      stat = File.stat(text_file_path)
      #puts "#{text_file_path} -> mtime: #{stat.mtime}"
      #puts "stat.mtime.class: #{stat.mtime.class}"
      if !last_mtime or stat.mtime > last_mtime
        last_mtime = stat.mtime
        last_page = page_name(text_file_path)
      end
    end
    last_page
  end
  def last_few_pages
    last_n_pages(@config.last_num_pages)
  end
  def last_n_pages(n)
    text_file_paths = get_text_file_paths
    pages = []
    text_file_paths.each do |text_file_path|
      stat = File.stat(text_file_path)
      page_name = page_name(text_file_path)
      page = WikiPage.new(page_name, stat.mtime) 
      pages << page
    end

    now = Time.now
    sorted_by_mtime = pages.sort_by do |page|
      now-page.mtime
    end
    
    page_names = []
    sorted_by_mtime[0,n].each do |wikipage|
      #puts "wikipage.class: #{wikipage.class}"
      page_names << wikipage.page_name 
    end
    page_names
  end
end
