# -*- coding: utf-8 -*-
require 'spec_helper'

describe BRGS::Builder do
  it 'should be better unit tested'

  it 'works in general' do
    parse_paper_rdf
    walk_paper_paths
    build_paper_sparse_matrix

    BRGS::Indexes.template_count.should eq 7
  end
end
