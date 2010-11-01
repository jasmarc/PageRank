$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require "test/unit"
require "pp"
require "Page"
require "yaml"

class TestPage < Test::Unit::TestCase
  def test_page
    page = Page.new(1, "http://www.infosci.cornell.edu/index.html")
    puts page
    puts page.to_yaml
    pp page
  end
  
  def test_page_includes
    page = Page.new(1, "http://www.infosci.cornell.edu/index.html")
    page.anchors = ["quick", "brown fox", "dog"]
    assert(page.include?("quick"), "page includes quick")
    assert(page.include?("QUICK"), "page includes QUICK")
    assert(page.include?("QuIcK"), "page includes QuIcK")
    assert(page.include?("brown"), "page includes brown")
    assert(page.include?("bro"), "page includes bro")
    assert(!page.include?("hello"), "page does not include hello")
  end
  
  def test_page_includes_any
    page = Page.new(1, "http://www.infosci.cornell.edu/index.html")
    page.anchors = ["quick", "brown fox", "dog"]
    assert(page.includes_any?(["quick", "hello"]), "page includes quick or hello")
    assert(!page.includes_any?(["bye", "hello"]), "page doesn't includes bye or hello")
    assert(page.includes_any?(["quick", "brown"]), "page includes quick or brown")
    assert(page.includes_any?(["QUICK", "hello"]), "page includes QUICK or hello")
    assert(!page.includes_any?(["bye", "hello"]), "page doesn't includes bye or hello")
    assert(page.includes_any?(["QuIcK", "brown"]), "page includes QuIcK or brown")
  end
end