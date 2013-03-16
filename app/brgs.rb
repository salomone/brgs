module BRGS
  def self.admission name, contents
    Resque.enqueue RDFAdmission, contents
  end

  def self.spider name
    Resque.enqueue GraphSpider, name
  end

  def self.node_query node
    selected_node = BRGS::Search.node node
    BRGS::Queries.node_query selected_node
  end
end
