require 'resque'
require "./app/jobs/rdf_admission"
require "./app/jobs/rdf_parsing"
require "./lib/file_splitter"

describe RDFAdmission do
  it "should enqueue 3 jobs when splitter splits file in three" do
    FileSplitter.stub(:split).and_return(Array.new(3) {|i| "fake-file-split-#{i}"})

    Resque.should_receive(:enqueue).with(RDFParsing, "test_paper", "paper.nt", 'fake-file-split-0').and_return(true)
    Resque.should_receive(:enqueue).with(RDFParsing, "test_paper", "paper.nt", 'fake-file-split-1').and_return(true)
    Resque.should_receive(:enqueue).with(RDFParsing, "test_paper", "paper.nt", 'fake-file-split-2').and_return(true)

    described_class.perform("test_paper", "paper.nt")
  end
end
