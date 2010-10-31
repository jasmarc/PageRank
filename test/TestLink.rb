require "test/unit"
require "yaml"
require "pp"
require "Link"

class TestLink < Test::Unit::TestCase
  def test_link
    link = Link.new(1, "http://www.infosci.cornell.edu/index.html", "home")
    puts link
    puts link.to_yaml
    pp link
  end
end