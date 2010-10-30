require "test/unit"
require "Resolver"
require "pp"

class TestResolver < Test::Unit::TestCase
  def test_resolver
    expected = "http://www.google.com/intl/en/about.html"
    actual = Resolver.resolve "http://www.google.com/about"
    assert_equal expected, actual
  end
  
  def test_relative
    expected = "http://www.google.com/intl/en/about.html"
    actual = Resolver.resolve "./about", "http://www.google.com/"
    assert_equal expected, actual
  end
  
  def test_info_sci
    expected = "http://www.infosci.cornell.edu/about"
    actual = Resolver.resolve "./about", "http://www.infosci.cornell.edu"
    assert_equal expected, actual
  end
  
  def test_info_sci
    expected = "http://www.infosci.cornell.edu/about/index.html"
    actual = Resolver.resolve "./about/index.html", "http://www.infosci.cornell.edu"
    assert_equal expected, actual
  end
  
  def test_broken_link
    expected = nil
    actual = Resolver.resolve "./about"
    assert_equal expected, actual
  end
end