require "set"
require "Link"

class Page
  attr_accessor :id, :url, :title, :links, :anchors, :rank
  def initialize(id, url)
    @id, @url = id, url
    @links = Hash.new
    @anchors = Set.new
  end
  
  def to_s
    "Page<id=#{@id} title=#{@title} url=#{@url} links=#{@links} anchors=#{@anchors}>"
  end
end