data "template_file" "redis_slave_config" {
  template = "${file("${path.module}/templates/slave_config.tpl")}"

  vars {
    master_pass       = "${var.master_pass}"
    master_ip_address = "${coalesce("${var.master_ip}", "${element(values(var.nodes), 0)}")}"
  }
}

data "template_file" "redis_sentinel_config" {
  template = "${file("${path.module}/templates/sentinel_config.tpl")}"

  vars {
    cluster_name      = "${var.cluster_name}"
    master_pass       = "${var.master_pass}"
    master_ip_address = "${coalesce("${var.master_ip}", "${element(values(var.nodes), 0)}")}"
  }
}

data "template_file" "redis_haproxy_config" {
  template = "${file("${path.module}/templates/haproxy.tpl")}"

  vars {
    master_pass       = "${var.master_pass}"
    node_names             = "${join(",", keys(var.nodes))}"
    node_ips             = "${join(",", values(var.nodes))}"
  }
}
