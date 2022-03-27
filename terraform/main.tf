variable aws_region {
  default = "us-east-1"
  type    = string
}

variable aws_profile {
  default = "default"
  type    = string
}

variable mysqlHost {
  type = string
}

variable mysqlUser {
  type = string
}

variable mysqlPass {
  type = string
}

variable mysqlDB {
  type = string
}

variable subnetIds {
  type = list(string)
}

variable securityGroupIds {
  type = list(string)
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

terraform {
  backend "s3" {
    key = "maas2.tfstate"
    bucket = "apollorion-us-east-1-tfstates"
    region = "us-east-1"
  }
}