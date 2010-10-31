require "Page"
require "LinkCrawler"
require "yaml"

class PageCollection
  attr_accessor :pages
  def initialize(file)
    @pages = Hash.new
    File.read(file).split("\n").map do |row| 
      id, url = row.split("\t")
      id = id.to_i
      @pages[url] = Page.new(id, url)
    end
  end
  
  def include? url
    !@pages[url].nil?
  end
  
  def [] url
    @pages[url]
  end
  
  def save(file)
    File.open(file, "w") {|file| file.puts(@pages.to_yaml) }
  end
  
  def load(file)
    File.open(file, "r") { |file| @pages = YAML.load(file) }
  end
  
  def crawl
    threads = []
    puts "crawling ..."
    @pages.each_value do |page|
      puts "#{page.id}\t- [#{page.url}]"
      crawler = LinkCrawler.new(page.url)
      crawler.each do |u, a|
        threads << Thread.new(u, a) do |linked_url, anchor|
          if(self.include? linked_url)
            linked_page = self[linked_url]
            linked_page.anchors << anchor unless anchor.nil? or anchor.empty?
            page.links[linked_url] = Link.new(linked_page.id, linked_url, anchor)
            puts "\t * Link from page #{page.id}: [#{anchor}]\t[#{linked_url}]"
          end
        end
      end
    end
    threads.each {|t| t.join}
    puts "done crawling!"
  end
end