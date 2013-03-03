class NetworkBuilder

  def self.ec2
    @ec2 ||= AWS::EC2.new
  end

  def self.topology
    topology = {:redis => nil, :servers => []}
    self.ec2.instances.each do |instance|
      if (instance.status == :running) && (instance.tags.has_key? 'brgs_roles')
        server = {}
        roles = instance.tags['brgs_roles'].split(',').map {|i| i.to_sym}

        if roles.include? :redis
          topology[:redis] = instance.private_dns_name
        end

        server[:dns] = instance.dns_name
        server[:internal] = instance.private_dns_name
        server[:roles] = roles

        if instance.tags.has_key? 'brgs_foreman_concurrency'
          server[:concurrency] = instance.tags['brgs_foreman_concurrency']
        end
        
        topology[:servers].push server
      end
    end

    return topology
  end

  def self.servers_rb
    topology = self.topology
    return ERB.new(File.read('servers.rb.erb')).result(binding)
  end

end
