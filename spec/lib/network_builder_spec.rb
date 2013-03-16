# -*- coding: utf-8 -*-
require 'spec_helper'

describe NetworkBuilder do
  def topology_for instances
      ec2_instances = OpenStruct.new :instances => instances
      described_class.should_receive(:ec2).and_return(ec2_instances)
      described_class.topology
  end

  def instance options
    options[:status] = :running
    OpenStruct.new options
  end

  def inactive_instance options
    options[:status] = :stopped
    OpenStruct.new options
  end

  shared_examples 'an empty topology' do
    it 'and returns a nil redis and an empty servers list' do
      topology = topology_for instances
      topology[:redis].should be_nil
      topology[:servers].should be_empty
    end
  end

  context 'when detecting topology' do
    context 'and there are no instances' do
      it_behaves_like 'an empty topology' do
        let(:instances) { [] }
      end
    end

    context 'and there are no instances with brgs_roles set' do
      it_behaves_like 'an empty topology' do
        let(:instances) do
          [
            instance(:tags => {:a_tag => 'a-value'}),
            instance(:tags => {:b_tag => 'b-value'}),
            instance(:tags => {:c_tag => 'c-value'})
          ]
        end
      end
    end

    context 'and there are instances with brgs_roles' do
      it 'splits the brgs_roles tags for roles as symbols' do
        instances = [
          instance(:tags => {'brgs_roles' => 'a_role,b_role'})
        ]

        topology = topology_for instances
        topology[:servers].first[:roles].should =~ [:a_role, :b_role]
      end

      it 'returns servers dns and internal names from the instances' do
        instances = [
          instance({
            :tags => {'brgs_roles' => 'a_role,b_role'},
            :dns_name => 'public-server-name',
            :private_dns_name => 'internal-server-name'
          })
        ]

        topology = topology_for instances
        topology[:servers].first[:dns].should eq 'public-server-name'
        topology[:servers].first[:internal].should eq 'internal-server-name'
      end

      it 'sets the last instance with redis role as the redis server' do
        instances = [
          instance({
            :tags => {'brgs_roles' => 'redis'},
            :private_dns_name => 'server-one'
          }),
          instance({
            :tags => {'brgs_roles' => 'redis'},
            :private_dns_name => 'server-two'
          })
        ]

        topology = topology_for instances
        topology[:redis].should eq 'server-two'
      end

      it 'sets foreman concurrency when found' do
        instances = [
          instance({
            :tags => {'brgs_roles' => 'a-role',
                  'brgs_foreman_concurrency' => 'concurrency_rules'}
          })
        ]

        topology = topology_for instances
        topology[:servers].first[:concurrency].should eq 'concurrency_rules'
      end

      it 'ignores foreman concurrency when not set' do
        instances = [ instance({:tags => {'brgs_roles' => 'a-role'}}) ]

        topology = topology_for instances
        topology[:servers].first.keys.should_not include :concurrency
      end

      it 'ignores inactive instances' do
        instances = [
          instance({:tags => {'brgs_roles' => 'a-role'}}),
          inactive_instance({:tags => {'brgs_roles' => 'a-role'}})
        ]

        topology = topology_for instances
        topology[:servers].size.should eq 1
      end
    end
  end
end
