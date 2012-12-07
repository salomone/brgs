# -*- coding: utf-8 -*-
require 'spec_helper'

describe RDFAdmission do
  segments = [
    {first: 1, last: 4},
    {first: 5, last: 8},
    {first: 9, last: 12}
  ]

  it "extracts 3 pieces and enqueues 3 jobs when splitter splits file in 3"
end
