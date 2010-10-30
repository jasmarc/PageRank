require "test/unit"
require "pp"
require "Page"
require "yaml"

class TestPage < Test::Unit::TestCase
  def test_page
    page = Page.new("http://www.infosci.cornell.edu/index.html")
    page.crawl_links
  end
end