# tf_redis_sentinel
Module to provision sentinel related configs for further usage by redis cluster

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
