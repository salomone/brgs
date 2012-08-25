require 'resque'
require './app/jobs/rdf_admission'

Resque.redis.namespace = "resque:brgs"
# Resque.enqueue(RDFAdmission, 'paper', 'example-rdfs/tall/paper.nt')
Resque.enqueue(RDFAdmission, 'paper', 'example-rdfs/venti/linkedmdb-latest-dump.nt')
