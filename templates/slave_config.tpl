slaveof ${master_ip_address} 6380
masterauth ${master_pass}
requirepass ${master_pass}
appendonly yes
port 6380
