defaults REDIS
	mode tcp
	timeout connect  4s
	timeout server  30s
	timeout client  30s
 
frontend ft_redis
	bind *:6379 name redis
	default_backend bk_redis
 
backend bk_redis
	option tcp-check
	tcp-check connect
	tcp-check send AUTH ${master_pass}\r\n
	tcp-check expect string OK
	tcp-check send PING\r\n
	tcp-check expect string +PONG
	tcp-check send info\ replication\r\n
	tcp-check expect string \#\ Replication\r\n
	tcp-check expect string role:master\r\n
	tcp-check send QUIT\r\n
	tcp-check expect string +OK
${join("\n", formatlist("\tserver %v %v:6380 check inter 1s", node_names, node_ips))}
