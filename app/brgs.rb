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

  def self.path_intersection_retrieval_query path
    selected_path = BRGS::Search.path path.split ','
    BRGS::Queries.path_intersection_retrieval_query selected_path
  end

  def self.path_cutting_start_query path, node
    selected_path = BRGS::Search.path path.split ','
    selected_node = BRGS::Search.node node
    BRGS::Queries.path_cutting_start_query selected_path, selected_node
  end

  def self.path_cutting_end_query path, node
    selected_path = BRGS::Search.path path.split ','
    selected_node = BRGS::Search.node node
    BRGS::Queries.path_cutting_end_query selected_path, selected_node
  end

  def self.katz_node_query node, katz_weigth=0.8, top_k=20
    selected_node = BRGS::Search.node node
    BRGS::Queries.node_katz_query selected_node, katz_weigth, top_k
  end

end
