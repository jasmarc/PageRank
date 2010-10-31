require "rubygems"
require "logger"
require "gsl"
include GSL

class PageRank
  @@log = Logger.new(File.dirname(__FILE__) + "/../logs/pagerank.log")

  def self.sparse_to_dense(sparse, alpha=0.14)
    n = sparse.size
    m = Matrix.ones(sparse.size, sparse.size)*(alpha/n.to_f)
    sparse.each do |row, columns|
      if(columns.empty?)
        1.upto(n) do |col|
          m[row - 1, col - 1] = 1.0/n.to_f
        end
      else
        d = columns.size.to_f
        columns.each do |col|
          m[row - 1, col - 1] = (1 - alpha).to_f/d.to_f + (alpha.to_f/n.to_f)
        end
      end
    end
    m
  end
  
  def self.pagerank(prob_mat)
    @@log.debug("starting pagerank ...")
    n = prob_mat.size1
    r = Vector.alloc(n)
    diff = Vector.alloc(n)
    diff.set_all(1)
    r[0] = 1
    while(diff.max > 1.0/(n*100)) do
    #500.times do
      @@log.debug("#{r}")
      r_prime = r*prob_mat
      diff = r - r_prime
      r = r_prime
    end
    @@log.debug("finished pagerank!")
    r
  end
end