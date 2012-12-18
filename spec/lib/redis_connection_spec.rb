# -*- coding: utf-8 -*-
require 'spec_helper'

describe RedisConnection do
  class DummyUsingRedisConnection
    include RedisConnection
  end

  it 'returns a namespaced connection using settings redis' do
    Settings.should_receive(:redis).
      any_number_of_times.
      and_return(OpenStruct.new({
        :namespace => 'bogus_namespace',
        :to_hash => {:host => 'localhost', :port => 6379}
      }))

    DummyUsingRedisConnection.new.redis.namespace.should eq 'bogus_namespace'
  end
end
