
variable "vpc_id" {
  type = string

}

variable "subnet_id" {
  type = string

}

variable "ec_ami" {
  type = string

}

variable "instance_type" {
  type = string

}

variable "key_name" {
  type = string

}


variable "pub_ip_associate" {
  type    = bool
  default = false
}

variable "create_instance" {
  type    = bool
  default = false

}

