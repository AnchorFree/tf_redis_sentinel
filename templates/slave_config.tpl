slaveof ${master_ip_address} 6380
masterauth ${master_pass}
requirepass ${master_pass}
save 60 1000
appendonly no
port 6380
