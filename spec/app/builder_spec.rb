# -*- coding: utf-8 -*-
require 'spec_helper'

describe BRGS::Builder do
  it 'should be better unit tested'

  it 'works in general' do
    build_data

    BRGS::Indexes.template_count.should eq 7
  end
end
