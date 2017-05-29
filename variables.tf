variable "cluster_name" {
  description = "Name of the redis cluster, must be unique"
}

variable "user" {
    default = ""
    description = "Initial user to connect and provision"
}

variable "ssh_port" {
    default = "22"
    description = "Initial port for ssh connection"
}

variable "nodes" {
  type        = "list"
  description = "IPs of the redis servers, first will be configured as a master"
}
