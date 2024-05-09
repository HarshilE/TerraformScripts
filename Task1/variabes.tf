variable "vpc_name" {
  description = "Name of the VPC"
  default     = "myVPCtask"
}

variable "pub-sub-1_cidr" {
  description = "CIDR block for the primary public subnet"
  default     = "10.20.1.0/24"
}

variable "pub-sub-2_cidr" {
  description = "CIDR block for the secondary public subnet"
  default     = "10.20.2.0/24"
}

variable "pvt-sub-1_cidr" {
  description = "CIDR block for the primary private subnet"
  default     = "10.20.16.0/20"
}

variable "pvt-sub-2_cidr" {
  description = "CIDR block for the secondary private subnet"
  default     = "10.20.32.0/20"
}

variable "availability_zone_1" {
  description = "Availability Zone for the primary subnets"
  default     = "ap-south-1a"
}

variable "availability_zone_2" {
  description = "Availability Zone for the secondary subnets"
  default     = "ap-south-1b"
}
