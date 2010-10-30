class Link
  attr_accessor :id, :url, :anchor
  def initialize(id, url, anchor)
    @id, @url, @anchor = id, url, anchor
  end
  
  def to_s
    "Link<id=#{@id} url=#{@url} anchor=#{@anchor}>"
  end
end