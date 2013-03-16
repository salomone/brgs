# -*- coding: utf-8 -*-
require 'spec_helper'

describe BRGS::Parser do
  it 'should be better unit tested'

  it 'works in general' do
    parse_paper_rdf

    BRGS::Indexes.node_count.should eq 13
    BRGS::Indexes.source_count.should eq 3
    BRGS::Indexes.sink_count.should eq 7
  end

  it 'parses lines ending in typed literals' do
    line = '<http://zbw.eu/stw/descriptor/18076-5> <http://purl.org/ontology/gbv/gvkppn> "091370388"^^<http://www.w3.org/2001/XMLSchema#string> .'

    c = mock('Parser')
    c.should_receive(:use_triple).with(
      'http://zbw.eu/stw/descriptor/18076-5',
      'http://purl.org/ontology/gbv/gvkppn',
      '091370388',
      true
    ).once

    BRGS::Parser.parse_line line do |s, p, o, o_triple|
      c.use_triple s, p, o, o_triple
    end
  end

  it 'parses lines ending in simple literals' do
    line = '<http://zbw.eu/stw/descriptor/18076-5> <http://purl.org/ontology/gbv/gvkppn> "091370388" .'

    c = mock('Parser')
    c.should_receive(:use_triple).with(
      'http://zbw.eu/stw/descriptor/18076-5',
      'http://purl.org/ontology/gbv/gvkppn',
      '091370388',
      true
    ).once

    BRGS::Parser.parse_line line do |s, p, o, o_triple|
      c.use_triple s, p, o, o_triple
    end
  end

  it 'parses lines ending in uris' do
    line = '<http://zbw.eu/stw/descriptor/18076-5> <http://purl.org/ontology/gbv/gvkppn> <http://www.w3.org/2001/XMLSchema#string> .'

    c = mock('Parser')
    c.should_receive(:use_triple).with(
      'http://zbw.eu/stw/descriptor/18076-5',
      'http://purl.org/ontology/gbv/gvkppn',
      'http://www.w3.org/2001/XMLSchema#string',
      false
    ).once

    BRGS::Parser.parse_line line do |s, p, o, o_triple|
      c.use_triple s, p, o, o_triple
    end
  end

  it 'ignore unmatching lines' do
    line = '<http://zbw.eu/stw/descriptor/18076-5> <http://purl.org/ontology/gbv/gvkppn> dedede .'

    c = mock('Parser')
    c.should_not_receive(:use_triple)

    BRGS::Parser.parse_line line do |s, p, o, o_triple|
      c.use_triple s, p, o, o_triple
    end
  end
end
