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
end
