require "Page"

class PageCollection
  attr_accessor :pages
  def initialize(file)
    @pages = Hash.new
    File.read(file).split("\n").map do |row| 
      id, url = row.split("\t")
      id = id.to_i
      @pages[url] = Page.new(self, id, url)
    end
  end
  
  def include? url
    !@pages[url].nil?
  end
  
  def [] url
    @pages[url]
  end
  
  def crawl
    threads = []
    @pages.each_value do |p| 
      threads << Thread.new(p) do |page|
        page.crawl_links
      end
    end
    threads.each {|t| t.join}
  end
end