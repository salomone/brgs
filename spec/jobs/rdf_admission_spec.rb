# -*- coding: utf-8 -*-
require 'spec_helper'

describe RDFAdmission do
  segments = [
    {first: 1, last: 4},
    {first: 5, last: 8},
    {first: 9, last: 12}
  ]

  it "extracts 3 pieces and enqueues 3 jobs when splitter splits file in 3" do
    FileSplitter.stub(:segment).and_return(segments)

    FileSplitter.should_receive(:piece).with("paper.nt", segments[0]).and_return("fake-split-0")
    FileSplitter.should_receive(:piece).with("paper.nt", segments[1]).and_return("fake-split-1")
    FileSplitter.should_receive(:piece).with("paper.nt", segments[2]).and_return("fake-split-2")

    Resque.should_receive(:enqueue).with(RDFParsing, "test_paper", 'fake-split-0').and_return(true)
    Resque.should_receive(:enqueue).with(RDFParsing, "test_paper", 'fake-split-1').and_return(true)
    Resque.should_receive(:enqueue).with(RDFParsing, "test_paper", 'fake-split-2').and_return(true)

    described_class.perform("test_paper", "paper.nt")
  end
end
