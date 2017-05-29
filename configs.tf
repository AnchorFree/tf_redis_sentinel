data "template_file" "redis_slave_config" {
  template = "${file("${path.module}/templates/slave_config.tpl")}"

  vars {
    master_ip_address = "${coalesce("${var.master_ip}", "${var.nodes[0]}")}"
  }
}

data "template_file" "redis_sentinel_config" {
  template = "${file("${path.module}/templates/sentinel_config.tpl")}"

  vars {
    cluster_name      = "${var.cluster_name}"
    master_ip_address = "${coalesce("${var.master_ip}", "${var.nodes[0]}")}"
  }
}
