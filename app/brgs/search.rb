module BRGS
  class Search
    extend RedisConnection

    def self.node node_text
      BRGS::Indexes.find_index('node', node_text).to_i
    end

    def self.path path_array
      path = []
      path_array.each_with_index do |element, i|
        path << BRGS::Indexes.find_index(i.even? ? 'node' : 'edge', element)
      end

      BRGS::Indexes.find_index('path', path.join(',')).to_i
    end

  end
end
