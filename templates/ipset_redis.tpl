create redis hash:ip
${join("\n", formatlist("add redis %v", split(",", node_ips)))}
