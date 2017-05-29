resource "null_resource" "cluster" {
  count = "${var.count == 0 ? 0 : length(var.nodes)}"
  triggers {
    master_ip = "${coalesce("${var.master_ip}", "${element(values(var.nodes), 0)}")}"
  }

  connection {
    user        = "${coalesce("${var.user}","root")}"
    type        = "ssh"
    private_key = "${module.creds.do_priv_key}"
    timeout     = "2m"
    port        = "${var.ssh_port}"
    host        = "${length(var.nodes_public_ips) > 0 ? element(values(var.nodes), count.index) : element(var.nodes_public_ips, count.index)}"
  }

  provisioner "file" {
    content     = "${data.template_file.redis_slave_config.rendered}"
    destination = "/tmp/redis-slave.config"
  }

  provisioner "file" {
    content     = "${data.template_file.redis_haproxy_config.rendered}"
    destination = "/tmp/redis-haproxy.cfg"
  }

  provisioner "file" {
    content     = "${data.template_file.redis_sentinel_config.rendered}"
    destination = "/tmp/redis-sentinel.config"
  }

  provisioner "remote-exec" {
    # copy file to the proper directory
    inline = [
      "mkdir -p /etc/redis",
      "sudo mv /tmp/redis* /etc/redis/",
      "chmod 0666 /etc/redis/*",
    ]
  }
}
