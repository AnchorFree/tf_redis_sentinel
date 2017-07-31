data "template_file" "redis_slave_config" {
  count    = "${var.count == "0" ? 0 : 1}"
  template = "${file("${path.module}/templates/slave_config.tpl")}"

  vars {
    master_pass       = "${var.master_pass}"
    master_ip_address = "${coalesce("${var.master_ip}", "${element(values(var.nodes), 0)}")}"
  }
}

data "template_file" "redis_master_config" {
  count    = "${var.count == "0" ? 0 : 1}"
  template = "${file("${path.module}/templates/master_config.tpl")}"

  vars {
    master_pass = "${var.master_pass}"
  }
}

data "template_file" "redis_sentinel_config" {
  count    = "${var.count == "0" ? 0 : 1}"
  template = "${file("${path.module}/templates/sentinel_config.tpl")}"

  vars {
    cluster_name      = "${var.cluster_name}"
    quorum            = "${length(var.nodes) > 2 ? 2 : 1 }"
    master_pass       = "${var.master_pass}"
    master_ip_address = "${coalesce("${var.master_ip}", "${element(values(var.nodes), 0)}")}"
  }
}

data "template_file" "redis_haproxy_config" {
  count    = "${var.count == "0" ? 0 : 1}"
  template = "${file("${path.module}/templates/haproxy.tpl")}"

  vars {
    master_pass = "${var.master_pass}"
    node_names  = "${join(",", keys(var.nodes))}"
    node_ips    = "${join(",", values(var.nodes))}"
  }
}

data "template_file" "redis_ipset_config" {
  template = "${file("${path.module}/templates/ipset_redis.tpl")}"

  vars {
    node_ips = "${join(",", values(var.nodes))}"
  }
}
