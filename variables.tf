variable "cluster_name" {
  description = "Name of the redis cluster, must be unique"
}

variable "count" {
  default     = "1"
  description = "if it is 0 - we don't create it, if != 0 - we generate configs based on amount of nodes"
}

variable "user" {
  default     = ""
  description = "Initial user to connect and provision"
}

variable "master_pass" {
  description = "Password to monitor master server"
}

variable "ssh_port" {
  default     = "22"
  description = "Initial port for ssh connection"
}

variable "master_ip" {
  default     = ""
  description = "Redis master IP address"
}

variable "nodes_public_ips" {
  type        = "list"
  default     = []
  description = "IPs of the redis servers to connect for provisioning, if not defined, nodes is used instead"
}

variable "nodes" {
  type        = "map"
  description = "name = IP map of the redis servers, first will be configured as a master if no master_ip defined"
}
