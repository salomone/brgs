class PrintUtils
  extend RedisConnection

  def self.path path_index
    out = ''
    path_string = redis.hget 'path', path_index
    path = path_string.split ','
    path.each_with_index do |e, i|
      i.even? ? out += redis.hget('node', e) : out += redis.hget('edge', e)
      out += "\n"
    end
    out
  end

  def self.indexes
    out = ''

    nodes_count = redis.get 'nodes_count'
    1.upto(nodes_count.to_i) do |node_index|
      node = redis.hget 'node', node_index
      out += node.split('#')[-1]
      out += "\n"
    end

    out += "\n"

    paths_count = redis.get 'paths_count'
    1.upto(paths_count.to_i) do |path_index|
      path_string = redis.hget 'path', path_index
      path = path_string.split ','
      p = []

      path.each_with_index do |e, i|
        i.even? ? p << redis.hget('node', e).split('#')[-1] : p << redis.hget('edge', e).split('#')[-1]
      end

      out += p.join '-'
      out += "\n"
    end

    out += "\n"

    templates_count = redis.get 'templates_count'
    1.upto(templates_count.to_i) do |template_index|
      template_string = redis.hget 'template', template_index
      template = template_string.split ','
      t = ['*']

      template.each_with_index do |e, i|
        t << redis.hget('edge', e).split('#')[-1]
        t << '*'
      end

      out += t.join '-'
      out += "\n"
    end

    out
  end

  def self.sparse_matrix
    paths_count = redis.get 'paths_count'
    nodes_count = redis.get 'nodes_count'

    out = '-;'
    out += (1..nodes_count.to_i).to_a.join ';'
    out += "\n"

    1.upto(paths_count.to_i) do |path_index|
      line = [path_index]
      1.upto(nodes_count.to_i) do |node_index|
        position = redis.hget 'matrix', "#{path_index}:#{node_index}"
        line << "(#{position})"
      end
      out += line.join ';'
      out += "\n"
    end

    out
  end

end
