# -*- coding: utf-8 -*-
require 'spec_helper'

describe RDFParsing do
  paper_file = File.open "spec/assets/paper.nt"

  context "when performing a job" do
    it "creates a rdf parsing instance" do
      mock = double("RDFParsing")
      RDFParsing.should_receive(:new).with("paper", paper_file).and_return(mock)
      mock.should_receive(:perform).and_return(true)
      described_class.perform("paper", paper_file)
    end
  end

  context "when parsing an rdf string" do
    subject {described_class.new "paper", paper_file}

    it "parses each line of of the file"
  end
end
