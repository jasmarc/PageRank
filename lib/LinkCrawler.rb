require "rubygems"
require "open-uri"
require "nokogiri"
require "logger"
require "Resolver"

BROKEN_LINKS = ["http://sigchi.infosci.cornell.edu/index.html"]

class String
  def starts_with?(prefix)
    prefix = prefix.to_s
    self[0, prefix.length] == prefix
  end
end

class LinkCrawler
  attr_accessor :page_title, :page_snippet
  @@log = Logger.new(File.dirname(__FILE__) + "/../logs/crawler.log")
  def initialize(url)
    @url = url
    @links = []
    begin
      open(url) do |f|
        doc = Nokogiri::HTML.parse f.read
        @page_title = get_page_title(doc)
        @page_snippet = get_page_snippet(doc)
        doc.css('a').each do |link|
          @links << { :url    => link['href'],
                      :anchor => get_anchor(link) }
        end
      end
    rescue Exception => ex
      @@log.error "url = #{@url} #{ex.message}"
    end
  end

  def each(&block)
    @links.each do |link|
      url = link[:url]
      if(!url.nil? and !url.starts_with? "mailto:" and \
          !BROKEN_LINKS.include? url)
        url = Resolver.resolve(url, @url)
        if(!url.nil? and url.include? "infosci.cornell.edu")
          yield url.gsub(/#.*$/,""), link[:anchor]
        end
      else
        @@log.debug "skipping [#{url}]"
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
    anchor.gsub(/[\n\r]/, "").squeeze(" ").strip
  end

  def get_page_title(doc)
    proper_title = doc.css("title").first.text
    alternate_title = doc.css("span.pageTitle").first
    if !alternate_title.nil?
      alternate_title = alternate_title.content.strip
    end
    if (proper_title.empty? or proper_title == "Cornell Information Science") \
       and !alternate_title.nil? and !alternate_title.empty?
      page_title = alternate_title
    else
      page_title = proper_title
    end
    if !page_title.nil?
      page_title = page_title.gsub(/[\n\r]/, "").squeeze(" ").strip
    end
    return page_title
  end
  
  def get_page_snippet(doc)
    doc_text = doc.inner_text.gsub(/&.*;|\s/," ").squeeze(" ")
    pos = doc_text.size/2
    return "#{doc_text[pos-50..pos+50]}"
  end
end