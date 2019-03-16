require 'wikipage'
require 'test/unit'

class WikiPageTest < Test::Unit::TestCase
  def setup
    @w = WikiPage.new('foo')
  end
  def test_get_text_file_path
    assert_equal('text/foo.txt', @w.get_text_file_path)
  end
  def test_new_with_mtime
    wiki_new = WikiPage.new('bar', Time.now)
    puts wiki_new.mtime.to_s
    wiki_old = WikiPage.new('bar-old', Time.now-3600)
    list = [wiki_old, wiki_new]
    now = Time.now
    sorted = list.sort_by do |wikipage|
      [now-wikipage.mtime, wikipage]
    end
    puts "*** sorted ***"
    puts sorted
  end
  def test_to_html_array
    def @w.get_text_file_path
      'foo.txt'
    end
    def @w.readlines(text_file_path)
      result = []
      result << 'h1. title'
      result << '<pre>'
      result << '  def hello_world'
      result << '    puts "hello world"'
      result << '  end'
      result << '</pre>'
      result << ''
      result << 'b. TODO List'
      result << '* write code'
      result << '* write docs'
      result << '** biz req doc'
      result << '** functional spec'
      result << '* review code'
      result << '** review release scripts'
      result << '** review feature foo'
      result << 'some *bolded value* text'
      result << '# first item'
      result << '# second item'
      result << '## nested item A'
      result << '* "github simplewiki":http://github.com/skanade/simplewiki/'
      result << 'footer'

    end
    puts @w.to_html_array
  end
  def test_to_redcloth_sections
    lines = []
    lines << "h1. title"
    lines << "h2. header"
    sections = @w.to_redcloth_sections(lines)
    assert_equal(2, sections.size)
  end
  def test_to_redcloth_sections_list_unordered
    lines = []
    lines << "Fruits"
    lines << "* orange"
    lines << "* apple"
    lines << "* banana"
    sections = @w.to_redcloth_sections(lines)
    assert_equal(2, sections.size)
  end
  def test_to_redcloth_sections_list_ordered
    lines = []
    lines << "Todo list"
    lines << "# laundry"
    lines << "# wash dishes"
    lines << "# iron shirts"
    lines << "(Need to complete tomorrow)"
    lines << "* homework"
    lines << "* taxes"
    sections = @w.to_redcloth_sections(lines)
    assert_equal(4, sections.size)
    is_laundry = false
    sections.each do |section|
      if is_laundry and section.include?("laundry")
        fail "laundry was listed twice!"
      end
      if section.include?("laundry")
        is_laundry = true
      end
    end
  end

end

