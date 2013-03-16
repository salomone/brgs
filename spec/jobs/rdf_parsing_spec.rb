# -*- coding: utf-8 -*-
require 'spec_helper'

describe RDFParsing do

  context 'performing a job' do
    it 'delegates' do
      paper_file = File.open 'spec/assets/paper.nt'
      rdf_segment = paper_file.read

      BRGS::Parser.
          should_receive(:parse_segment).
          with('paper', rdf_segment)

      described_class.perform('paper', rdf_segment)
    end
  end

end
