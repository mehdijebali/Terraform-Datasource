# Terraform-Datasource
In this Demo, we will deploy an EC2 instance with security group using AWS Datasource, generate output attributes related to the provisioned instance, and configure terraform remote state with AWS S3 service.
## Datasource
Terraform provides DataSource for AWS Cloud Provider. It represents the dynamic Information about entities that
are not managed by the current Terraform configuration. This data is structured and can be accessed via AWS APIs. In fact, we can expose informations using datasource such as IPs, Availability Zones, ...
In this case, we use datasource to find the available zones and the latest ubuntu image:
```
data "aws_availability_zones" "available" {}

data "aws_ami" "latest-ubuntu" {
  most_recent = true
  owners = ["099720109477"]

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
```


