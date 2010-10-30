require "set"
require "LinkCrawler"
require "Resolver"
require "Link"

class Page
  attr_accessor :id, :url, :title, :links, :anchors
  def initialize(page_collection, id, url)
    @page_collection, @id, @url = page_collection, id, url
    @links = Hash.new
    @anchors = Set.new
  end
  
  def crawl_links
    crawler = LinkCrawler.new(@url)
    threads = []
    crawler.each do |u, a|
      threads << Thread.new(u, a) do |url, anchor|
        url = Resolver.resolve(url)
        if(@page_collection.include? url)
          page = @page_collection[url]
          page.anchors << anchor unless anchor.nil? or anchor.empty?
          @links[url] = Link.new(page.id, url, anchor)
          puts "#{@url} #{url}"
        end
      end
      threads.each {|t| t.join}
    end
  end
  
  def to_s
    "Page<id=#{@id} title=#{@title} url=#{@url} links=#{@links} anchors=#{@anchors}>"
  end
end