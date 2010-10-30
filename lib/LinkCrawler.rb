require "rubygems"
require "open-uri"
require "nokogiri"
require "Logger"

class String
  def starts_with?(prefix)
    prefix = prefix.to_s
    self[0, prefix.length] == prefix
  end
end

class LinkCrawler
  attr_accessor :page_title
  def initialize(url)
    @log = Logger.new(File.dirname(__FILE__) + "/../logs/crawler.log")
    @url = url
    @links = []
    begin
      open(url) do |f|
        doc = Nokogiri::HTML.parse f.read
        get_page_title(doc)
        doc.css('a').each do |link|
          @links << { :url    => link['href'],
                      :anchor => get_anchor(link) }
        end
      end
    rescue Exception => ex
      @log.error "url = #{@url} #{ex.message}"
      puts "url = #{@url} #{ex.message}"
    end
  end

  def each(&block)
    @links.each do |link|
      if(!link[:url].nil? and link[:url].starts_with? "http://" \
        and link[:url].include? "infosci.cornell.edu")
        yield link[:url].gsub(/#.*$/,""), link[:anchor]
      end
    end
  end

private
  def get_anchor(link)
    if(!link.children.first.nil?)
      anchor = link.children.first.text.to_s
      if anchor.empty?
        anchor = link.children.first.attributes['alt'].to_s
      end
    end
    anchor
  end

  def get_page_title(doc)
    proper_title = doc.css("title").first.text
    alternate_title = doc.css("span.pageTitle").first
    if !alternate_title.nil?
      alternate_title = alternate_title.content.strip
    end
    if (proper_title.empty? or proper_title == "Cornell Information Science") \
       and !alternate_title.nil? and !alternate_title.empty?
      @page_title = alternate_title
    else
      @page_title = proper_title
    end
    @page_title = @page_title.gsub("\n", "").squeeze(" ")
  end
end