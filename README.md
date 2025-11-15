# EFK_stack_MVP

## General Idea
- The general idea here is to use architecture where fluent-bit sits as forwarder next to whatever source it should forward logs from ( ideally as "close" as possible to that source )
- also use fluent-bit as aggregator before finally forwarding logs to elasticsearch. Here i am choosing fluent-bit as well, i dont see a reason to choose fluentd unless we have a specific problem to solve that we cant achieve with fluent-bit (less resource heavy, uses the same type of config, and possibly just lua instead of lua and ruby, as the forwarders so it also adds a bit more to simplicity)
- Elasticsearch in this solution shouldnt need any sharding, security features etc., thats more of a production and "at scale" issue than MVP
- I probably shouldnt bother saving credentials somewhere in the scope of this homework, but otherwise it would probably reside in Hvault or Hvault fork of the cloud provider
- most likely i will create just 2 dashboards in kibana, 1 for logs to read and some variations with filters, the second one probably for extracted values from those logs that will be visible in graphs
- in the middle of fluent forwarder and aggregator i will add kafka since i feel like its more complete solution at scale and is really helpful in achieving it 

## Notes

Thinking of 2 solutions because the infrastructure where this is deployed isnt described almost at all in my opinion so:

Option 1:
spin up 2 EC2 instances with linux distro and run the MVP using docker-docompose with:
1. EC2 for compose with fluent-bit aggregator, ES, Kibana
2. EC2 for compose with some kind of webserver, fluent-bit forwarder + script that loops couple different types of curl requests to generate logs
also one of these needs to run prometheus + grafana ( alerting wasnt mentioned, not adding alertmanager )

Option 2:
spin up small EKS cluster and do the above but with k8 in mind

Will go with Option 1 and hope k8 would be specific if that was the goal here and is described as MVP so MVP it is :D

kafkamagic - https://www.kafkamagic.com/download/


fluent-bit -> kafka -> fluentd (or flient-bit but there is some sinanigans happening with dashes under underscores and elastic has issues with dashes for some reason, not sure if its just later implamenteaion of kafka doesnt like undercores too)
there are kafka-keys that can help you to have logs one by one how they appeared (but without use case elastic can just order these by timestamp)
you can create parallelism in kafka ( basically you somehow devide 1 kafka topic to multiple streams or smth and then there can be 20 flient-bits on one side or the other that take care of things way faster )

