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
## Output Attribute
Terraform keeps track of all resources and its attributes, so it is possible to query and retain outputs and use it for provisionnig other resources. We obtain output attributes afer running `terraform apply`. In contrast, outputs will not be rendered while running `terraform plan`.
In this example, we query the instance IP addresses (public, private) using two different methods:
#### Output Block
Each output value exported by a module can be declared using an output block: 
```
output "public_ip" {
  value = aws_instance.MyFirstInstnace.public_ip 
}
```
The value argument takes an expression whose result is to be
returned to the user.
#### Script
We can execute script that expose the required value by using the provisioner block which is configured inside the resource block:
```
provisioner "local-exec" {
    command = "echo ${aws_instance.MyFirstInstnace.private_ip} >> my_private_ips.txt"
  }
```
## Remote State
Remote is useful for creating remote backend that solves the problems of:
#### Manual error
Once you configure a remote backend, Terraform will automatically load the state file from that backend every time you run plan or apply and it will automatically store the state file in that backend after each apply, so there’s no chance of manual error.
#### Locking
Most of the remote backends natively support locking. When you run `terraform apply`, Terraform will automatically acquire a lock; if someone else is already running apply, they will already have the lock, and you will have to wait.
#### Secrets
Most of the remote backends natively support encryption in transit and encryption on disk of the state file.

We proceed with saving the remote state in S3 bucket, the file **backend.tf** contains the S3 bucket configuration:
```
terraform {
    backend "s3" {
        bucket = "tf-s3-backend"
        key    = "development/terraform_state"
        region = "us-east-1"
    }
}
```

