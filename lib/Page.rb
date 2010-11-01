require "set"
require "Link"

class Page
  attr_accessor :id, :url, :title, :links, :anchors, :rank, :snippet
  def initialize(id, url)
    @id, @url = id, url
    @links = Hash.new
    @anchors = Set.new
  end
  
  def include? query
    !@anchors.nil? and !@anchors.empty? and @anchors.any? do |anchor|
      anchor.upcase.include?(query.upcase)
    end
  end
  
  def includes_any? query
    query.any? do |item|
      self.include? item
    end
  end
  
  def to_s
    "Page<id=#{@id} title=#{@title} url=#{@url} links=#{@links} anchors=#{@anchors}>"
  end
end