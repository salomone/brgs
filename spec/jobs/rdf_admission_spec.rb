require 'resque'
require "./app/jobs/rdf_admission"
require "./app/jobs/rdf_parsing"

describe RDFAdmission do
    subject { RDFAdmission }
    empty_file = "spec/assets/empty_file.txt"
    a_1_line_file = "spec/assets/1_line_file.txt"
    a_3_line_file = "spec/assets/3_lines_file.txt"
    paper_file = "spec/assets/paper.nt"

    it "detects empty files" do
        subject.empty?(empty_file).should eq(true)
    end

    it "detects files ending on newline" do
        subject.ends_with_newline?(paper_file).should eq(true)
    end

    it "detects files not ending on newline" do
        subject.ends_with_newline?(a_3_line_file).should eq(false)
    end

    it "counts 12 lines on a 12 lines file" do
        subject.count(paper_file).should eq(12)
    end

    it "counts 3 lines on a 3 lines file" do
        subject.count(a_3_line_file).should eq(3)
    end

    it "counts 1 line on a 1 line file" do
        subject.count(a_1_line_file).should eq(1)
    end

    it "counts 0 lines on an empty file" do
        subject.count(empty_file).should eq(0)
    end

    it "splits a 12 lines file on 3 pieces of 4 lines" do
        subject.stub(:lines_limit).and_return(4)
        subject.stub(:count).and_return(12)
        pieces = subject.split("")

        pieces.length.should eq(3)
        pieces.each { |v| (v[:last] - v[:first] + 1).should eq(4) }
    end

    it "doesn't split a file smaller than the lines limit" do
        subject.stub(:lines_limit).and_return(20)
        subject.stub(:count).and_return(10)
        pieces = subject.split("")

        pieces.length.should eq(1)
        (pieces[0][:last] - pieces[0][:first] + 1).should eq(10)
    end

    it "splits last piece smaller than the rest if division is not perfect" do
        subject.stub(:lines_limit).and_return(100)
        subject.stub(:count).and_return(123)
        pieces = subject.split("")

        pieces.length.should eq(2)
        (pieces[1][:last] - pieces[1][:first] + 1).should eq(23)
    end

    it "doesn't return pieces for empty files" do
        subject.stub(:count).and_return(0)
        subject.split("").should be_empty
    end

    it "should enqueue 3 jobs for a 12 lines rdf when line_limit is 4" do
        subject.stub(:lines_limit).and_return(4)
        subject.stub(:count).and_return(12)
        Resque.should_receive(:enqueue).with(RDFParsing, "test_paper", "paper.nt", {first: 0, last: 3}).and_return(true)
        Resque.should_receive(:enqueue).with(RDFParsing, "test_paper", "paper.nt", {first: 4, last: 7}).and_return(true)
        Resque.should_receive(:enqueue).with(RDFParsing, "test_paper", "paper.nt", {first: 8, last: 11}).and_return(true)

        subject.perform("test_paper", "paper.nt")
    end
end
