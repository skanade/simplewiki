require 'wikipage'
require 'simplewiki'
require 'test/unit'

class SimpleWikiTest < Test::Unit::TestCase
  def setup
    @wiki = SimpleWiki.new
  end
  def test_saved_page_names
    saved_page_names = @wiki.saved_page_names
    saved_page_names.each do |saved_page_name|
      assert !saved_page_name.end_with?('.txt')
    end
  end
  def test_search_for_text
    label_result,result = @wiki.search_for_text('h2') 
    result.each_key do |page_name|
      assert !page_name.end_with?('.txt')    
    end
  end
  def test_last_page_name
    last_page_name = @wiki.last_page_name
    puts "last_page_name: #{last_page_name}"
  end
  def test_last_n_pages
    last_3_pages = @wiki.last_n_pages(3)
    assert_equal 3, last_3_pages.size
    puts "*** last_3_pages ***"
    last_3_pages.each do |page|
      puts "  #{page}"
    end
  end
end


