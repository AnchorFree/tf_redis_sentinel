resource "null_resource" "cluster" {
  # terraform bug 10857 doesn't allow to compute count based on length(var.nodes)
  count = "${var.count}"
  triggers {
    nodes = "${join(",", values(var.nodes))}"
  }

  connection {
    user        = "${coalesce("${var.user}","root")}"
    type        = "ssh"
    private_key = "${module.creds.do_priv_key}"
    timeout     = "2m"
    port        = "${var.ssh_port}"
   # terraform bug 14399 workaround
    host        = "${length(var.nodes_public_ips) == 0 ? format("%s", element(concat(values(var.nodes), list("")), count.index)) : format("%s", element(concat(var.nodes_public_ips, list("")), count.index))}"
  }

  provisioner "file" {
    content     = "${count.index == 0 ? data.template_file.redis_master_config.rendered : data.template_file.redis_slave_config.rendered}"
    destination = "/tmp/redis-server.conf"
  }

  provisioner "file" {
    content     = "${data.template_file.redis_haproxy_config.rendered}"
    destination = "/tmp/redis-haproxy.conf"
  }

  provisioner "file" {
    content     = "${data.template_file.redis_sentinel_config.rendered}"
    destination = "/tmp/redis-sentinel.conf"
  }

  provisioner "remote-exec" {
    # copy file to the proper directory
    inline = [
      "mkdir -p /etc/redis",
      "rmdir /etc/redis/redis-*.conf || true",
      "sudo mv /tmp/redis* /etc/redis/",
      "chmod 0666 /etc/redis/*",
    ]
  }
}
