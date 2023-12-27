variable "dummy" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "bucket_key" {
  type = string
  
}

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

variable "need_encrypt" {
  type = bool
  default = true
  
}

variable "pub_ip_associate" {
  type = bool
  default = false
}

