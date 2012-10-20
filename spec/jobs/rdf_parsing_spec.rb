require "./app/jobs/rdf_parsing"

describe RDFParsing, "parser" do
  paper_file = "spec/assets/paper.nt"

  it "needs better testing"

  it "parses each line of of the file" do
    RDFParsing.should_receive(:parse_line).exactly(12)
    described_class.perform("paper", paper_file, {first: 0, last: 11})
  end
end
