module BRGS
  class Queries

    def self.node_query node
      BRGS::SparseMatrix.column(node).keys.map {|k| k.to_i}
    end

    def self.path_query path
      BRGS::SparseMatrix.row(path).keys.map {|k| k.to_i}
    end

    def self.final_node_query node
      BRGS::SparseMatrix.column(node).select do |path, cell|
        tuple = cell.split(',')
        tuple[0] == tuple[1]
      end.keys.map {|k| k.to_i}
    end

  end
end
