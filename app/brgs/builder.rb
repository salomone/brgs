module BRGS
  class Builder

    def self.build path_index
      
      path_string = BRGS::Indexes.get 'path', path_index
      path = path_string.split ','

      
      template = odds path
      template_string = template.join ','
      ti, = BRGS::Indexes.index 'template', template_string

      nodes = evens path
      nodes.each_with_index do |node_index, pos|
        tuple = [pos + 1, nodes.size, ti].join ','
        BRGS::SparseMatrix.store_position node_index, path_index, tuple
      end

    end



    def self.odds(a)
      a.values_at(* a.each_index.select {|i| i.odd?})
    end

    def self.evens(a)
      a.values_at(* a.each_index.select {|i| i.even?})
    end

  end
end
