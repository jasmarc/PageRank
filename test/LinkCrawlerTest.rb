$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require "rubygems"
require "test/unit"

require "LinkCrawler"

class TestLinkCrawler < Test::Unit::TestCase
  def test_crawler
    crawler = LinkCrawler.new("http://www.infosci.cornell.edu/")
    crawler.each do |url, anchor|
      puts "[#{url}] [#{anchor}]"
    end
  end
  
  def test_title
    crawler = LinkCrawler.new("http://www.infosci.cornell.edu/ugrad/index.html")
    expected = "Undergraduate Majors"
    actual = crawler.page_title
    assert_equal expected, actual
  end
  
  def test_titles
    File.read("test3-smaller.txt").split("\n").map do |row| 
      id, url = row.split("\t")
      id = id.to_i
      crawler = LinkCrawler.new(url)
      puts "[#{crawler.page_title}]\t[#{crawler.page_snippet}]"
    end
  end
end