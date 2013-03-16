# -*- coding: utf-8 -*-
require 'spec_helper'

describe BRGS::Parser do
  it 'should be better unit tested'

  it 'works in general' do
    parse_paper

    BRGS::Indexes.node_count.should eq 13
    BRGS::Indexes.source_count.should eq 3
    BRGS::Indexes.sink_count.should eq 7
  end
end
