# -*- coding: utf-8 -*-
require 'spec_helper'

describe BRGS::Search do
  it 'finds a node' do
    build_data
    
    node_index_found = described_class.node 'Hitchcock'
    node_index_found.should eq 4
  end

  it 'finds a path' do
    build_data

    path_array = [
      'http://demo.com/director.rdf#dir1',
      'http://demo.com/syntax#directed',
      'http://demo.com/movie.rdf#mov1',
      'http://www.w3.org/1999/02/22-rdf-syntax-ns#name',
      'The Avengers'
    ]

    path_index_found = described_class.path path_array
    path_index_found.should eq 3
  end
end
