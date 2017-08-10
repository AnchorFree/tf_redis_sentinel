resource "null_resource" "redis-haproxy" {
  # terraform bug 10857 doesn't allow to compute count based on length(var.nodes)
  count = "${var.count}"

  triggers {
    nodes = "${join( ",", values(var.nodes))}"
  }

  connection {
    user        = "${coalesce("${var.user}","root")}"
    type        = "ssh"
    private_key = "${module.creds.do_priv_key}"
    timeout     = "2m"
    port        = "${var.ssh_port}"

    # terraform bug 14399 workaround
    host = "${length(var.nodes_public_ips) == 0 ? format("%s", element(concat(values(var.nodes), list("")), count.index)) : format("%s", element(concat(var.nodes_public_ips, list("")), count.index))}"
  }

  provisioner "file" {
    content     = "${data.template_file.redis_haproxy_config.rendered}"
    destination = "/tmp/redis-haproxy.conf"
  }

  provisioner "file" {
    content     = "${data.template_file.redis_ipset_config.rendered}"
    destination = "/tmp/ipset-redis.conf"
  }

  provisioner "remote-exec" {
    # copy file to the proper directory
    inline = [
      "test -d /etc/redis || sudo mkdir -p /etc/redis",
      "sudo rmdir /etc/redis/redis-haproxy.conf 2>/dev/null || true",
      "sudo mv /tmp/redis-haproxy.conf /etc/redis/ || true ",
      "sudo mv /tmp/ipset-redis.conf /etc/ipset/redis.conf || true ",
      "sudo chmod 0666 /etc/redis/*",
    ]
  }
}

resource "null_resource" "redis-sentinel" {
  # terraform bug 10857 doesn't allow to compute count based on length(var.nodes)
  count = "${var.count}"

  triggers {
    nodes = "${join( ",", values(var.nodes))}"
  }

  connection {
    user        = "${coalesce("${var.user}","root")}"
    type        = "ssh"
    private_key = "${module.creds.do_priv_key}"
    timeout     = "2m"
    port        = "${var.ssh_port}"

    # terraform bug 14399 workaround
    host = "${length(var.nodes_public_ips) == 0 ? format("%s", element(concat(values(var.nodes), list("")), count.index)) : format("%s", element(concat(var.nodes_public_ips, list("")), count.index))}"
  }

  provisioner "file" {
    content     = "${count.index == 0 ? data.template_file.redis_master_config.rendered : data.template_file.redis_slave_config.rendered}"
    destination = "/tmp/redis-server.conf"
  }

  provisioner "file" {
    content     = "${data.template_file.redis_sentinel_config.rendered}"
    destination = "/tmp/redis-sentinel.conf"
  }

  provisioner "remote-exec" {
    # copy file to the proper directory
    inline = [
      "test -d /etc/redis || sudo mkdir -p /etc/redis",
      "test -f /etc/redis/configured || sudo docker rm -f haproxy-redis redis-server redis-sentinel || true",
      "sudo rmdir /etc/redis/redis-sentinel.conf 2>/dev/null || true",
      "sudo rmdir /etc/redis/redis-server.conf 2>/dev/null || true",
      "sudo mv -n /tmp/redis* /etc/redis/",
      "sudo chmod 0666 /etc/redis/*",
      "sudo /bin/systemctl reload ipset-restore.service || true",
      "test -f /etc/redis/configured || sudo /usr/local/bin/docker-updater.sh run || true",
      "sudo touch /etc/redis/configured",
    ]
  }
}
