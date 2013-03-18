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

    expected_response = {:q => path, :nodes => [8, 1, 2]}

    get "/path_query.json?q=#{URI::encode path}"
    last_response.should be_ok
    last_response.body.should eq expected_response.to_json
  end
end
