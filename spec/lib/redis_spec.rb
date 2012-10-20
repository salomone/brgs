# -*- coding: utf-8 -*-
require 'spec_helper'

describe RedisConnection do
  class DummyUsingRedisConnection
    extend RedisConnection
  end

  it "returns a namespaced connection based on rack environment" do
    old_rack_env = ENV['RACK_ENV']
    ENV['RACK_ENV'] = 'bogus_rack_env_test'

    DummyUsingRedisConnection.redis.namespace.should eq "bogus_rack_env_test:bgrs"

    ENV['RACK_ENV'] = old_rack_env
  end
end
