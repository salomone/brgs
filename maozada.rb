# require 'resque'
# require './app/jobs/rdf_admission'

# Resque.redis.namespace = "resque:brgs"
# # Resque.enqueue(RDFAdmission, 'paper', 'example-rdfs/tall/paper.nt')
# Resque.enqueue(RDFAdmission, 'paper', 'example-rdfs/venti/linkedmdb-latest-dump.nt')


require 'rdf'
require 'rdf/ntriples'

first = 4
last = 7
rdf = "example-rdfs/tall/paper.nt"

rdf_string = `sed -n #{first + 1},#{last + 1}p #{rdf}`

RDF::Reader.for(:ntriples).new(rdf_string) do |reader|
  reader.each_statement do |statement|
    s, p, o = statement.to_triple
    puts s, p, o
  end
end
