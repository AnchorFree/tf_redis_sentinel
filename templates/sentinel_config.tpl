# I've hardcoded quorum value to 2, to prevent overwriting configs during scale up/down
sentinel monitor ${cluster_name} ${master_ip_address} 6380 2
sentinel down-after-milliseconds ${cluster_name} 5000
sentinel parallel-syncs ${cluster_name} 1
sentinel failover-timeout ${cluster_name} 10000
sentinel auth-pass ${cluster_name} ${master_pass}
