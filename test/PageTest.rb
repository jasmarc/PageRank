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
end