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
    paths_found.each do |path_index|
      path = BRGS::Indexes.get 'path', path_index
      path.split(',')[-1].to_i.should eq node
    end
  end

  it 'finds if path intersect each other' do
    build_data

    path1_array = [
      'http://demo.com/director.rdf#dir1',
      'http://demo.com/syntax#directed',
      'http://demo.com/movie.rdf#mov1',
      'http://www.w3.org/1999/02/22-rdf-syntax-ns#name',
      'The Avengers'
    ]

    path2_array = [
      'http://demo.com/director.rdf#dir1',
      'http://demo.com/syntax#directed',
      'http://demo.com/movie.rdf#mov1',
      'http://demo.com/syntax#year',
      '2012'
    ]

    path1_index = BRGS::Search.path path1_array
    path2_index = BRGS::Search.path path2_array

    intersect = described_class.path_intersection_query path1_index, path2_index
    intersect.should be_true
  end

  it 'finds paths that intersect another' do
    build_data

    path_array = [
      'http://demo.com/director.rdf#dir1',
      'http://demo.com/syntax#directed',
      'http://demo.com/movie.rdf#mov1',
      'http://www.w3.org/1999/02/22-rdf-syntax-ns#name',
      'The Avengers'
    ]

    path_index = BRGS::Search.path path_array

    paths = described_class.path_intersection_retrieval_query path_index
    paths.should eq [1, 2, 3, 4, 5, 6]
  end

  it 'finds path section before given node' do
    build_data

    path_array = [
      'http://demo.com/director.rdf#dir1',
      'http://demo.com/syntax#directed',
      'http://demo.com/movie.rdf#mov1',
      'http://www.w3.org/1999/02/22-rdf-syntax-ns#name',
      'The Avengers'
    ]

    path_index = BRGS::Search.path path_array
    node = BRGS::Search.node 'http://demo.com/movie.rdf#mov1'

    nodes = described_class.path_cutting_start_query path_index, node
    nodes.should eq [8, 1]
  end

  it 'finds path section after given node' do
    build_data

    path_array = [
      'http://demo.com/director.rdf#dir1',
      'http://demo.com/syntax#directed',
      'http://demo.com/movie.rdf#mov1',
      'http://www.w3.org/1999/02/22-rdf-syntax-ns#name',
      'The Avengers'
    ]

    path_index = BRGS::Search.path path_array
    node = BRGS::Search.node 'http://demo.com/movie.rdf#mov1'

    nodes = described_class.path_cutting_end_query path_index, node
    nodes.should eq [1, 2]
  end

end
