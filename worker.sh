#!/bin/sh
VVERBOSE=1 QUEUES=rdf_admission,rdf_parsing rake worker:start
