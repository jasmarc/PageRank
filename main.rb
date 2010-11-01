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
  puts "Horray! I didn't have to crawl. Crawl results are cached in 'collection.yaml'"
  collection.load(FILE)
end

link_matrix = collection.pages.values.map do |page| 
  [page.id, page.links.values.map {|link| link.id}]
end

link_matrix = PageRank.sparse_to_dense(link_matrix, 0.2)
page_ranks = PageRank.pagerank(link_matrix).to_a
collection.pages.each_value do |page|
  page.rank = page_ranks[page.id - 1]
end

puts "Short Index Record:"
File.open("metadata", "w") do |f|
  collection.pages.values.sort {|a,b| b.rank <=> a.rank }.each do |page|
    f.puts "[#{page.id}]\t[#{page.rank}]\t[#{page.anchors.to_a.join(', ')}]"
    puts "Title: [#{page.title}]\tAnchor: [#{page.anchors.to_a.join(', ')}]"
  end
end

def query(collection, q)
  case q
  when String:
    collection.pages.values.find_all do |page|
      page.include? q
    end.sort { |a, b| b.rank <=> a.rank}.map do |page|
      "[#{page.title}]\n\t[#{page.url}]\n\t[#{page.snippet}]"
    end.join("\n")
  when Array:
    collection.pages.values.find_all do |page|
      page.includes_any? q
    end.sort { |a, b| b.rank <=> a.rank}.map do |page|
      "[#{page.title}]\n\t[#{page.url}]\n\t[#{page.snippet}]"
    end.join("\n")
  end
end

puts "Enter a query or type 'ZZZ' to end."
ARGF.each do |line|
  words = line.split
  if(words.size == 1)
    exit if words[0] == "ZZZ"
    puts query(collection, words[0])
  elsif(words.size > 1)
    puts query(collection, words)
  else
    puts "Enter a query or type 'ZZZ' to end."
  end
end