# -*- coding: utf-8 -*-
require 'spec_helper'
require 'rack/test'

describe "master_controller" do
  include Rack::Test::Methods

  def app
    @app ||= Resque::Server.new
  end

  it 'returns paths as json' do
    build_data

    node = 'http://demo.com/movie.rdf#mov1'
    expected_response = {:q => node, :paths => [2, 3, 4, 5, 6]}

    get "/node_query.json?q=#{URI::encode node}"
    last_response.should be_ok
    last_response.body.should eq expected_response.to_json
  end

  it 'returns nodes as json' do
    build_data

    path = [
      'http://demo.com/director.rdf#dir1',
      'http://demo.com/syntax#directed',
      'http://demo.com/movie.rdf#mov1',
      'http://www.w3.org/1999/02/22-rdf-syntax-ns#name',
      'The Avengers'
    ].join ','

    node1 = BRGS::Search.node 'http://demo.com/director.rdf#dir1'
    node2 = BRGS::Search.node 'http://demo.com/movie.rdf#mov1'
    node3 = BRGS::Search.node 'The Avengers'

    expected_response = {:q => path, :nodes => [node1, node2, node3]}

    get "/path_query.json?q=#{URI::encode path}"
    last_response.should be_ok
    last_response.body.should eq expected_response.to_json
  end

  it 'returns paths ending in a node as json' do
    build_data

    node = 'Hitchcock'

    path1 = BRGS::Search.path [
      'http://demo.com/director.rdf#dir2',
      'http://demo.com/syntax#directed',
      'http://demo.com/movie.rdf#mov2',
      'http://www.w3.org/1999/02/22-rdf-syntax-ns#name',
      'Hitchcock'
    ]

    path2 = BRGS::Search.path [
      'http://demo.com/director.rdf#dir3',
      'http://www.w3.org/1999/02/22-rdf-syntax-ns#name',
      'Hitchcock'
    ]

    expected_response = {:q => node, :paths => [path1, path2]}

    get "/final_node_query.json?q=#{URI::encode node}"
    last_response.should be_ok
    last_response.body.should eq expected_response.to_json
  end
end
