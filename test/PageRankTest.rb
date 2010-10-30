require "test/unit"
require "pp"
require "PageRank"

class TestPageRank < Test::Unit::TestCase
  def test_sparse_matrix
    expected = [[0.02, 0.02, 0.88, 0.02, 0.02, 0.02, 0.02],
                [0.02, 0.45, 0.45, 0.02, 0.02, 0.02, 0.02],
                [0.31, 0.02, 0.31, 0.31, 0.02, 0.02, 0.02],
                [0.02, 0.02, 0.02, 0.45, 0.45, 0.02, 0.02],
                [0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.88],
                [0.02, 0.02, 0.02, 0.02, 0.02, 0.45, 0.45],
                [0.02, 0.02, 0.02, 0.31, 0.31, 0.02, 0.31]]
    actual = PageRank.sparse_to_dense([[1, [3]], 
                                       [2, [2, 3]], 
                                       [3, [1, 3, 4]], 
                                       [4, [4, 5]], 
                                       [5, [7]], 
                                       [6, [6, 7]], 
                                       [7, [4, 5, 7]]], 0.14)
    expected.each_with_index do |row, j|
      row.each_with_index do |element, i|
        assert_equal(element*100, (actual[j, i]*100).round, "#{i} #{j}")
      end
    end
    actual.to_a.each do |row|
      pp row.inject {|a,b| a+b}
    end
    pagerank_actual = PageRank.pagerank(actual)
    pp pagerank_actual
    pagerank_expected = Vector[0.0521,
                               0.0351,
                               0.1120,
                               0.2456,
                               0.2135,
                               0.0351,
                               0.3066]
    pagerank_expected.to_a.each_with_index do |element, x|
      assert (element - pagerank_actual[x]).abs < 0.05, \
        "#{element} #{pagerank_actual[x]} #{element - pagerank_actual[x]}"
    end
    assert_equal(1, pagerank_expected.sum.round)
    assert_equal(1, pagerank_actual.sum.round)
  end
end