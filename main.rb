$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'
require "rubygems"
require "PageCollection"
require "pp"
require "PageRank"
require "yaml"

FILE = "collection.yaml"

collection = PageCollection.new("test3.txt")
if(!File.exist? FILE)
  collection.crawl
  collection.save(FILE)
else
  collection.load(FILE)
end

link_matrix = collection.pages.values.map do |page| 
  [page.id, page.links.values.map {|link| link.id}]
end

link_matrix = PageRank.sparse_to_dense link_matrix
page_ranks = PageRank.pagerank(link_matrix).to_a
collection.pages.each_value do |page|
  page.rank = page_ranks[page.id - 1]
end
File.open("output.txt", "w") do |f|
  collection.pages.values.sort {|a,b| b.rank <=> a.rank }.each do |page|
    f.puts "[#{page.rank}]\t[#{page.url}]\t[#{page.anchors.to_a.join(', ')}]"
  end
end