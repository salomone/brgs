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

  it 'finds all nodes given a path' do
    build_data

    path_array = [
      'http://demo.com/director.rdf#dir1',
      'http://demo.com/syntax#directed',
      'http://demo.com/movie.rdf#mov1',
      'http://www.w3.org/1999/02/22-rdf-syntax-ns#name',
      'The Avengers'
    ]

    path_index = BRGS::Search.path path_array

    nodes_found = described_class.path_query path_index
    nodes_found.should eq [8, 1, 2]
  end

  it 'finds all paths ending in a given a node' do
    build_data

    node = BRGS::Search.node 'Hitchcock'
    paths_found = described_class.final_node_query node
    paths_found.should eq [8, 13]
  end

end
