web: resque-web -L -F -N dev:brgs:resque
worker: rake VVERBOSE=1 QUEUES=* COUNT=3 resque:workers
