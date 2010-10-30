require "test/unit"
require "PageCollection"
require "pp"

class TestPageCollection < Test::Unit::TestCase
  def test_page_collection
    collection = PageCollection.new("test3-smaller.txt")
    collection.crawl
    foo = collection.pages.values.map do |page| 
      [page.id, page.links.values.map {|link| link.id}]
    end
    pp foo
  end
end