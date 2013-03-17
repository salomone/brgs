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

    def self.path_intersection_query path1, path2
      nodes1 = BRGS::SparseMatrix.row(path1).keys
      nodes2 = BRGS::SparseMatrix.row(path2).keys
      if nodes1.nil? or nodes2.nil?
        return false
      else
        return !(nodes1 & nodes2).empty?
      end
    end

  end
end
