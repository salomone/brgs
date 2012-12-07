web: rake resque:web
worker: rake VVERBOSE=1 QUEUES=* COUNT=3 resque:workers
redis: PREFIX=./redis rake redis:install dtach:install