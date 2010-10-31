$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require "test/unit"
require "PageCollection"
require "pp"
require "yaml"

class TestPageCollection < Test::Unit::TestCase
  def test_page_collection
    collection = PageCollection.new("test3-smaller.txt")
    collection.crawl
    foo = collection.pages.values.map do |page| 
      [page.id, page.links.values.map {|link| link.id}]
    end
    collection.save("test.yaml")
    link_matrix = collection.pages.values.map do |page| 
      [page.id, page.links.values.map {|link| link.id}]
    end
    pp link_matrix
  end
  
  def test_load_page_collection
    collection = PageCollection.new("test3-smaller.txt")
    collection.load("test.yaml")
    link_matrix = collection.pages.values.map do |page| 
      [page.id, page.links.values.map {|link| link.id}]
    end
    pp link_matrix
  end
  
  def test_titles
    collection = PageCollection.new("test3-smaller.txt")
    collection.crawl
    collection.pages.values.each do |page|
      puts "[#{page.title}]"
    end
  end
end