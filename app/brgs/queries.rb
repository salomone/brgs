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

    def self.path_intersection_retrieval_query path
      BRGS::SparseMatrix.row(path).keys.inject([]) {|r, n| r |= node_query(n)}
    end

    def self.path_cutting_start_query path, node
      row = BRGS::SparseMatrix.row(path)
      node_position = row[node.to_s].split(',')[0].to_i
      row.select do |node, cell|
        tuple = cell.split ','
        tuple[0].to_i <= node_position
      end.keys.map {|k| k.to_i}
    end

    def self.path_cutting_end_query path, node
      row = BRGS::SparseMatrix.row(path)
      node_position = row[node.to_s].split(',')[0].to_i
      row.select do |node, cell|
        tuple = cell.split ','
        tuple[0].to_i >= node_position
      end.keys.map {|k| k.to_i}
    end
  end
end
