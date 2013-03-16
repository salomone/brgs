# -*- coding: utf-8 -*-
require 'spec_helper'

describe BRGS::Walker do
  it 'should be better unit tested'

  it 'works in general' do
    parse_paper_rdf
    walk_paper_paths

    BRGS::Indexes.path_count.should eq 14
  end

  it 'invokes a callback for each new path' do
    c = mock('Crawler')
    c.should_receive(:print_path).exactly(14).times

    parse_paper_rdf
    described_class.destroy_paths_templates_sparse_matrix
    BRGS::Indexes.sources.each do |source|
      described_class.walk source do |path_index|
        c.print_path path_index
      end
    end
  end
end
