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

## Terraform
- creating 1 module for the ec2 instances, rest are basic resources in main.tf and network.tf + adding startup of puppet agents and server to use them later if there is time.
- after terraform apply finishes there just needs to be added my public IP into sec groups so i can run bash scripts that setup the whole thing instead of puppet for now.

## Puppet
- puppet - The major changes in puppet announced aorund august make it really hard for new user to understand what is going on, most puppet learning resources available are created before this and when you, for example want to generate a module using the generation tool, its deprecated so you gotta use PDK, but to use PDK you have to login to puppet forge but the description on how to authenticate via apt in docs is just terrible in my opinion, it wants specific values in /etc/apt/auth but completely fails in describing how they should be formatted. ( or i got it right and its some kind of WSL2 issue )

- For now i am gonna create just bash scripts that will setup the EC2 instances after terraform deploys them and if there is some time left I will configure that to be used by puppet ideally (at least the initial package installation).

- not even sure puppet really makes sense here (this was probably tought out to be as solution without using even docker, possibly), i would rather use ansible just for this mvp purpouses because its one time setup and doesnt need any server, agent communication + i am pretty sure CI/CD tool, like github here, would make even more sense after installing the basic tooling for purpose of deploying compose files.

## Kafka
- Although Kafka isnt part of the original task i felt like it would be nice to use it here for future reference about scaling to higher number of clients. At 100 or 1000 clients this tool provides very high value in terms of simplicity to connect multiple consumers to the messaging topic, use partition for parallel consumption and provision ( is also able to be configured with kafka keys that provide you with exact order how messages arrived, unlike normally where they can skip over and then be ordered at the destination by timestamp, which can be useful for certain use-cases ), taking the parsed data and sending them back to kafka and do something more with them etc. 

- at scale in kube - strimzi would probably be the nice way to go, recommanded by big part of community
- using jvm - graal not suited for prod according to docs
- usikng kraft mode to remove the need of zookeeper
- using kafkamagic tool to look inside kafka topics
- looking up best way for naming conventions in kafka (for topics, will also we used in fluent-bit for filters), choosing to use something like: business.dataset_type.data_type.environment.format

## fluent-bit
- choosing to use yaml format after some time since its encouraged by the maintainers and some features are already only supported with yaml
- using server ip address and ports instead of local dns in docker-compose because for some reason the logging driver of docker-compsose isnt able to register the internal dns during startup of containers with those records
- configuring small buffer for fluent-bit and parsing for docker logs, should also include different logs other than from docker source to showcase more

- log routing in fluent-bit will be done via tags in compose files. Each service can define 1 tag which can then be used to route specific log formats and either leave them raw (just pure single log field) or parse them to have even more structured log message.

- So far its pretty hard decide which solution is better, to either have multiple fluent-bits at scale as kafka consumers where each parses specific service or 1 fluent-bit per project with larger pipelines. This will more likely be solution/project specific other than anything else.

- When using purely fluent-bit -> fluent-bit/fluentd , it seems you can transfer tags  from forwarder to aggregator but with kafka its a bit more tricky, one needs to create new field with value of the current tag and at the destination ( the aggregator ) rewrite new tag added by input with value of this field since kafka output doesnt support any type of tag retention

- for scalability it would be good idea to do more of a deep dive into fluent-bit multithreading, i got the basic concept but it seems like a bit larger topic to understand in more detailed matter.
- adding specific compression type gzip between fluent-bit producer and kafka

## Elastic & Kibana
- using simple elastic deployment with 1 replica and with security turned off, same with kibana.
- This whoule solution is mainly focused, since its MVP for interview, to spin up all services without any residual data so kibana dashboards need to be somehow fed on start to it, for elastic i am just gonna leave it empty, its gonna fill will logs pretty fast after adding more log sources.

- Tought about using elasticsearch/kibana log parsing pipelines as well but it seems to not be the recommanded solution as you want fluent-bit as your tool of choice to take care of this and elastic should focus on its searching, analytics side of things, otherwise i would probably end up with fluent-bit doing almost nothing and heavily utilised elasticsearch.

- for kibana dashboards i am not really sure how to preserve them without having dedicated persistant volume of the elasticsearch as kibana saves all here data there which is not ideal for my current setup

- would be probably the best to add webserver curl caller to all ec2 instances, currently dashboards seems a bit dull since there is always only 1 public IP making the requests, also would be good to add mabye some dummy user agents etc.

## Grafana & Prometheus
- will try adding multiple exporters, use imported dashboards from grafana labs

- node_exporter should be the only one running on ec2 outisde docker since its supposed to monitor the system outside docker, rest in compose files
- Grafana needs to somehow load up after terraform deployment is done - using provision mode so that dashboards and datasources can be saved as files - best way to use grafana dashboards this way is to configure provisioning of datasource (grafana has endpoint to deliver currently configured fields in json via its api) and dashboards, but unfortunately most dashboard creators dont create variables for datasource in their dashboard so once imported, the entire dashboard json file is bound to the specific uuid of prometheus, fixed by adding fix uuid to defaults of provisioning config
