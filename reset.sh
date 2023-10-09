#!/bin/bash
#

do_reset () {
  rm -fr /tmp/kafka-streams/streams-wordcount/*
  docker-compose exec -it broker kafka-topics --bootstrap-server localhost:9092 --delete --topic streams-plaintext-input || true
  docker-compose exec -it broker kafka-topics --bootstrap-server localhost:9092 --create --topic streams-plaintext-input  --partitions 4 --replication-factor 1
  docker-compose exec -it broker kafka-topics --bootstrap-server localhost:9092 --delete --topic streams-wordcount-output || true
  docker-compose exec -it broker kafka-topics --bootstrap-server localhost:9092 --create --topic streams-wordcount-output --partitions 4 --replication-factor 1
  docker-compose exec -it broker kafka-streams-application-reset --bootstrap-server localhost:9092 --application-id streams-wordcount --input-topics streams-plaintext-input --intermediate-topics streams-wordcount-output
}


read -r -p "This operation will 1) destroy input/output/intermediate topics 2) destroy local state store 3) reset kafka streams application offsets. Are you sure? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        do_reset
        ;;
    *)
        exit 0
        ;;
esac


