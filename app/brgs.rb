module BRGS
  def self.admission name, contents
    Resque.enqueue RDFAdmission, contents
  end

  def self.spider name
    Resque.enqueue GraphSpider, name
  end
end
