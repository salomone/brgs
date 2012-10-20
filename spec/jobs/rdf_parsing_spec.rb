# -*- coding: utf-8 -*-
require 'spec_helper'

describe RDFParsing, "parser" do
  paper_file = File.open "spec/assets/paper.nt"

  it "needs better testing"

  it "parses each line of of the file" do
    RDFParsing.should_receive(:parse_line).exactly(12)
    described_class.perform("paper", paper_file)
  end
end
