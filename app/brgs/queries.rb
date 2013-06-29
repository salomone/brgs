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

    def self.node_katz_query node, katz_weigth=0.8, top_k=20
      #get the first level path list
      path_list = BRGS::SparseMatrix.column(node)
      results= Hash.new()
      
      #loop through this first level path list
      path_list.keys.each_with_index do |path_it|
        #path_size = path_list[path_it.to_s].split(',')[1]
        node_position= path_list[path_it.to_s].split(',')[0]
        

        #get directly connected nodes
        node_list = BRGS::SparseMatrix.row(path_it)

        node_list.keys.each_with_index do |node_it|
          temp_node_weigth = node_weigth node_it
          temp_node_position= node_list[node_it.to_s].split(',')[0]

          #Katz_Index
          katz = temp_node_weigth.to_i*(((temp_node_position.to_i - node_position.to_i).abs)**(katz_weigth.to_i))
          results[node_it]=[katz]
        end
      end

      #puts results


      #puts sorted_results
      puts katz_weigth
      return Hash[results.sort_by { |node, weigth| weigth }.reverse[0..("#{top_k}".to_i-1)]].keys
    end

    def self.path_katz_query path, node
      node_list = BRGS::SparseMatrix.row(path)
      node_list.delete(node)
      #get directly connected nodes
      path_ans = Hash.new()
      node_list.keys.each_with_index do |node_it|
        #calculate each second level node weigth
        node_weigth = node_katz_query(node_it,path,true)
        #node_position= node_list[node_it.to_s].split(',')[0]
        path_ans[node_it]=[node_weigth]
      end
      path_ans
    end

    def self.node_weigth node
      path_list = BRGS::SparseMatrix.column(node)
      node_weigth = 0
      path_list.keys.each_with_index do |path_it|
        path_size = path_list[path_it.to_s].split(',')[1]
        node_weigth +=path_size.to_i
      end
      node_weigth
    end


    
  end
end
