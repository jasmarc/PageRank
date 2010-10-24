require "rubygems"
require "pp"
require "open-uri"
require "nokogiri"
require "page_matrix"
require "gsl"
include GSL

class Assignment3
  attr_reader :pages

  def initialize(file, testing=false)
    if(testing)
      @pages = PAGE_MATRIX
    else
      # Get all of the pages from the passed in file
      @pages = get_pages(file)
      # For each page
      @pages.each do |page|
        # Go visit the page and get all the links
        links = extract_links(page[:url])
        # For each link
        links.each do |link|
          # If we keep track of the linked-to page
          if(@pages.any? {|p| p[:url] == link[:link_url]})
            # Add it to this page's collection of links
            page[:links] << link
          end
        end
      end
    end
  end

  # This opens the file and creates our main data-structure
  def get_pages(page_listing)
    # Create an array by splitting on lines
    File.read(page_listing).split("\n").map do |row| 
      # Within each line, split on tabs
      page_id, url = row.split("\t")
      page_id = page_id.to_i
      {:page_id => page_id,
       :page_title => get_page_title(url),
       :url => url,
       :links => []}
    end
  end

  # Here we're going to actually visit the passed in
  # URL and return a collection of links
  def extract_links(web_page)
    open(web_page) do |f|
      doc = Nokogiri::HTML.parse f.read
      doc.css('a').map do |x| 
        if(!x.children.first.nil?)
          link_text = x.children.first.text
        end
        {:link_url => x['href'], 
         :anchor_text => link_text,
         :page_id => get_page_id(x['href'])}
      end
    end
  end
  
  def get_page_title(web_page)
    open(web_page) do |f|
      doc = Nokogiri::HTML.parse f.read
      doc.css('title').first.text
    end
  end
  
  # Given a URL, we consult or @pages lookup table
  # to get the page_id
  def get_page_id(url)
    page = @pages.find { |p| p[:url] == url }
    if(page.nil?)
      nil
    else
      page[:page_id]
    end
  end
  
  # Given a dictionary-style representation of a matrix
  # we create a dense version
  def self.sparse_to_dense(sparse)
    # First create a matrix of all zeros
    m = Matrix::Int.zeros(sparse.size, sparse.size)
    # Now let's go through and add a one where needed
    sparse.each do |row, columns|
      columns.each do |col|
        m[row - 1, col - 1] = 1
      end
    end
    m
  end
  
  # INPUT: link structure matrix (NxN)
  # OUTPUT: pagerank scores
  def self.pagerank(g)
    raise if g.size1 != g.size2
    i = Matrix.I(g.size1)
    # identity matrix
    p = (1.0/g.size1) * Matrix.ones(g.size1,1) # teleportation vector
    s = 0.8 # probability of following a link
    t = 1-s # probability of teleportation
    t*((i-s*g).invert)*p
  end
end