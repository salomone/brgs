module BRGS
  class Queries

    def self.node_query node
      BRGS::SparseMatrix.column(node).keys.map {|k| k.to_i}
    end
  end
end
