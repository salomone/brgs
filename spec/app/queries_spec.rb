# -*- coding: utf-8 -*-
require 'spec_helper'

describe BRGS::Queries do
  it 'should be better unit tested'

  it 'finds all paths given a node' do
    build_data

    node = BRGS::Search.node 'http://demo.com/movie.rdf#mov1'
    paths_found = described_class.node_query node
    paths_found.should eq [2, 3, 4, 5, 6]
  end
end
