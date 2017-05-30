# tf_redis_sentinel
Module to provision sentinel related configs for further usage by redis cluster

### variables 

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `cluster_name` | string | NA | Name of the redis cluster, must be unique |
| `count` | string|  NA | Amount of nodes in cluster |
| `user` |   string  | "" | "Initial user to connect and provision" |
| `master_pass` | string | NA | "Password to connect to redis server" |
| `ssh_port` | string|  "22" | "Initial port for ssh connection" |
| `master_ip` | string| "" | "Redis master IP address" |
| `nodes_public_ips` | "list" | [] | "IPs of the redis servers to connect for provisioning, if not defined, nodes is used instead" |
| `nodes` | "map" | NA | "name = IP map of the redis servers, first will be configured as a master if no master_ip defined" |

### what it does

Basically it creates 3 files:

| File | Changed on scale | Description |
|------|------------------|-------------|
| /etc/redis/redis-snetinel.conf | No | Sentinel configuration, pointing quorum size, master server and cluster name. |
| /etc/redis/redis-server.conf | No| Depends on the server type (master or slave), it generates the file for the redis-server. |
| /etc/redis/redis-haproxy.conf | Yes | Listens to port 6379 (default redis) and peak master based on replication information | 

Real redis server is listening to port `6380`, while `6379` - is listened by HAproxy, which is targeting master server based on healthchecks, with maximum downtime of 3 seconds. 

In case yout client and your source code does support redis-sentinel, it is listening to port `26379`, this will point you to the master almost instantly, while if your code doesn't support HA mode, or you client doesn't - you can rely on HAproxy, which will do the same with 3 seconds (max) timeout. 
