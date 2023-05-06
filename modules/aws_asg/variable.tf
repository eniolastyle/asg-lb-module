variable "name_prefix" {
    type = string
}

variable "image_id" {
    type = string
}

variable "instance_type" {
    type = string
}

variable "key_name" {
    type = string
}

variable "security_group_id" {
    type = list(string)
}

variable "user_data" {
    type = string
}

variable "vpc_id" {
    type = string
}

variable "health_path" {
    type = string
}

variable "subnets_id" {
    type = list(string)
}

variable "max_size" {
    type = number
}

variable "min_size" {
    type = number
}

variable "desired_capacity" {
    type = number
}

variable "target_type" {
  type = string
}

variable "traffic_port" {
    type = number
}

variable "protocol" {
    type = string
}

