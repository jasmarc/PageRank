$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'
require "rubygems"
require "PageCollection"
require "pp"
require "PageRank"
require "yaml"

# This is the cache file. We don't want to spider if we don't
# have to. It takes a long time.
FILE = "collection.yaml"

# Let's read that file from Dr. Ginsparg
collection = PageCollection.new("test3.txt")
if(!File.exist? FILE)   # Are our results cached?
  collection.crawl      # No. Let's crawl!
  collection.save(FILE) # Let's save it for next time
else
  puts "Horray! I didn't have to crawl. Crawl results are cached in 'collection.yaml'"
  collection.load(FILE)
end

# Let's convert our data into a sparse matrix, e.g. something like this:
# [[1, [3]], 
#  [2, [2, 3]], 
#  [3, [1, 3, 4]]]
link_matrix = collection.pages.values.map do |page| 
  [page.id, page.links.values.map {|link| link.id}]
end

# Now we convert to a dense matrix, filling in with alpha = 0.2
link_matrix = PageRank.sparse_to_dense(link_matrix, 0.2)
# Now we compute PageRank
page_ranks = PageRank.pagerank(link_matrix).to_a
# Now let's weave the PageRank back into our main datastructure
collection.pages.each_value do |page|
  page.rank = page_ranks[page.id - 1]
end

# Let's produce the "metadata" file and Short Index Record
puts "Short Index Record:"
File.open("metadata", "w") do |f|
  collection.pages.values.sort {|a,b| b.rank <=> a.rank }.each do |page|
    f.puts "[#{page.id}]\t[#{page.rank}]\t[#{page.anchors.to_a.join(', ')}]"
    puts "Title: [#{page.title}]\tAnchor: [#{page.anchors.to_a.join(', ')}]"
  end
end

# This is our query function that's going to get used below
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

# This is our "Search Engine"
# We handle user input here
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