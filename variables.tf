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

variable "ssh_port" {
  default     = "22"
  description = "Initial port for ssh connection"
}

variable "nodes" {
  type        = "list"
  description = "IPs of the redis servers, first will be configured as a master"
}
