variable "headless_build" {
  type =  bool
  default = true
}

variable "memory_amount" {
  type =  string
  default = "2048"
}

variable "iso_name" {
  type    = string
  default = "CentOS-Stream-8-x86_64-latest-boot.iso"
}

variable "kickstart" {
  type    = string
  default = "ks/centos-8-stream.cfg"
}
