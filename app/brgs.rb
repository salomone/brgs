module BRGS
  def self.admission name, uri
    Resque.enqueue RDFAdmission, uri
  end

  def self.spider name
    Resque.enqueue GraphSpider, name
  end

  def self.node_query node
    selected_node = BRGS::Search.node node
    BRGS::Queries.node_query selected_node
  end

  def self.path_query path
    selected_path = BRGS::Search.path path.split ','
    BRGS::Queries.path_query selected_path
  end

  def self.final_node_query node
    selected_node = BRGS::Search.node node
    BRGS::Queries.final_node_query selected_node
  end

  def self.path_intersection_query path1, path2
    selected_path1 = BRGS::Search.path path1.split ','
    selected_path2 = BRGS::Search.path path2.split ','
    BRGS::Queries.path_intersection_query selected_path1, selected_path2
  end

end
