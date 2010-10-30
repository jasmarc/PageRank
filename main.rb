$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'
require "rubygems"
require "LinkCrawler"
require "Page"

collection = PageCollection.new("test3.txt")
collection.crawl
foo = collection.pages.values.map do |page| 
  [page.id, page.links.values.map {|link| link.id}]
end
pp foo