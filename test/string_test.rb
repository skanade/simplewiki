require 'redclothadapter'
require 'test/unit'

class StringTest < Test::Unit::TestCase
  def test_underscore_for_space
    s = "a page name with spaces"
    assert_equal("a_page_name_with_spaces", s.underscore_for_space)
  end
  def test_start_with_bullet_or_number
    assert "* item".start_with_bullet_or_number?
    assert "# ordered".start_with_bullet_or_number?
    assert !"h1. title".start_with_bullet_or_number?
    assert !"some text".start_with_bullet_or_number?
  end
end

