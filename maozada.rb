ENV['RACK_ENV'] ||= 'development'

require File.expand_path("#{File.dirname(__FILE__)}/../config/environment", __FILE__)
Resque.redis.namespace = "development:brgs:resque"

# Resque.enqueue RDFAdmission, 'paper', 'example-rdfs/tall/paper.nt'
# Resque.enqueue RDFAdmission, 'paper', 'example-rdfs/tall/fake.nt'
# Resque.enqueue RDFAdmission, 'paper', 'example-rdfs/tall/opus_august2007.nt'
# Resque.enqueue RDFAdmission, 'paper', 'example-rdfs/venti/linkedmdb-latest-dump.nt'
# Resque.enqueue GraphSpider, 'paper'

def redis
  Redis::Namespace.new "#{ENV['RACK_ENV']}:bgrs"
end

def puts_path path_index
  path_string = redis.hget 'path', path_index
  path = path_string.split ','
  path.each_with_index do |e, i|
    i.even? ? puts(redis.hget('node', e)) : puts(redis.hget('edge', e))
  end
end

debugger
puts ' go for it!'
