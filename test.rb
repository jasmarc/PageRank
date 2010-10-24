require "test/unit"
require "Assignment3.rb"

class TestPageRank < Test::Unit::TestCase
  def test_case_name
    asst3 = Assignment3.new("test3.txt", true)
    pp asst3.pages
  end

  def test_extract_links
    doc = Nokogiri::HTML.parse(<<-HTML_END)
    <div class="heat">
       <a href='http://example.org/site/1/'>site 1</a>
       <a href='http://example.org/site/2/'>site 2</a>
       <a href='http://example.org/site/3/'>site 3</a>
    </div>
    <div class="wave">
       <a href='http://example.org/site/4/'>site 4</a>
       <a href='http://example.org/site/5/'>site 5</a>
       <a href='http://example.org/site/6/'>site 6</a>
    </div>
    HTML_END

    pp doc.css('div.heat a')
  end

  def test_page_matrix
    foo = PAGE_MATRIX.map do |page| 
      links = page[:links].map {|y| y[:page_id]}
      [page[:page_id], links]
    end
    foo = Assignment3.sparse_to_dense foo
    Assignment3.pagerank(foo).each_row do |row|
      puts row
    end
  end

  def test_sparse_matrix
    expected = Matrix::Int[[1, 0, 1, 0],
                           [1, 0, 0, 0],
                           [0, 1, 0, 0],
                           [0, 0, 1, 0]]
    actual = [[1, [1, 3]], [2, [1]], [3, [2]], [4, [3]]]
    assert_equal expected, Assignment3.sparse_to_dense(actual)
  end

  def test_get_title
    open("http://www.google.com") do |f|
      doc = Nokogiri::HTML.parse f.read
      pp doc.css('title').first.text
    end
  end
end