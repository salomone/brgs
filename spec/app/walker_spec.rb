# -*- coding: utf-8 -*-
require 'spec_helper'

describe BRGS::Walker do
  it 'should be better unit tested'

  it 'works in general' do
    parse_paper_rdf
    walk_paper_paths

    BRGS::Indexes.path_count.should eq 14
  end
end
