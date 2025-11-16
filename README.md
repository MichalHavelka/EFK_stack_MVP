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

### Option 1:
---------
spin up 3 EC2 instances with linux distro and run the MVP using docker-compose with:
1. EC2 for compose with fluent-bit aggregator, ES, Kibana
2. EC2 for compose with some kind of webserver, fluent-bit forwarder + script that loops couple different types of curl requests to generate logs
3. EC2 for compose for apache kafka

also one of these needs to run prometheus + grafana ( alerting wasnt mentioned, not adding alertmanager )
### Option 2:
---------
1. spin up small EKS cluster and do the above but with k8 in mind
2. include github as well to take care of kube deployments

### Conclusion

Will go with Option 1 and hope k8 would be specific if that was the goal here and is described as MVP so MVP it is :D
fluent-bit -> kafka -> fluentd -> elasticsearch & kibana

prolly makes more sense to add 1 more ec2 instance for kafka alone

## Encountered issues so far
puppet - The major changes in puppet announced aorund august make it really hard for new user to understand what is going on, most puppet learning resources available are created before this and when you, for example want to generate a module using the generation tool, its deprecated so you gotta use PDK, but to use PDK you have to login to puppet forge but the description on how to authenticate via apt in docs is just terrible in my opinion, it wants specific values in /etc/apt/auth but completely fails in describing how they should be formatted. ( or i got it right and its some kind of WSL2 issue )

For now i am gonna create just bash scripts that will setup the EC2 instances after terraform deploys them and if there is some time left I will configure that to be used by puppet ideally (at least the initial package installation)

## Kafka
Although Kafka isnt part of the original task i felt like it would be nice to use it here for future reference about scaling to higher number of clients. At 100 or 1000 clients this tool provides very high value in terms of simplicity to connect multiple consumers to the messaging topic and even use partition for parallel consumption and provision ( is also able to be configured with kafka keys that provide you with exact order how messages arrived, unlike normally where they can skip over and then be ordered at the destination by timestamp, which can be useful for certain use-cases )

at scale in kube - strimzi would probably be the nice way to go, recommanded by big part of community
using jvm - graal not suited for prod according to docs
usikng kraft mode to remove the need of zookeeper
using kafkamagic tool to look inside kafka topics
looking up best way for naming conventions in kafka (for topics, will also we used in fluent-bit for filters), choosing to use something like: business.dataset_type.data_type.environment.format

## fluent-bit
choosing to use yaml format after some time since its encouraged by the maintainers and some features are already only supported with yaml
using server ip address and ports instead of local dns in docker-compose because for some reason the logging driver of docker-compsose isnt able to register the internal dns during startup of containers with those records
configuring small buffer for fluent-bit and parsing for docker logs, should also include different logs other than from docker source to showcase more

## Elastic & Kibana
using simple elastic deployment with 1 replica and with security turned off 


