variable "server_port" {
  description = "web server port"
  default     = 8080
}

variable "cluster_name" {
  description = "cluster"
}

variable "db_remote_state_bucket" {
  description = "key"
}

variable "db_remote_state_key" {
  description = "key"
}

variable "instance_type" {
  description = "type"
}

variable "min_size" {
  description = "min ASG"
}

variable "max_size" {
  description = "max ASG"
}