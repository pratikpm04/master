variable "AWS_REGION" {    
    default = "ap-south-1"
}
provider "aws" {
    region = "${var.AWS_REGION}"
}

resource "aws_vpc" "prodvpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = "false" #gives you an internal domain name
    enable_dns_hostnames = "false" #gives you an internal host name
    
  
}
   
resource "aws_subnet" "prodsubnetpublic1" {
    vpc_id = "${aws_vpc.prodvpc.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "eu-west-2a"
  
} 



resource "aws_internet_gateway" "prod-igw" {
    vpc_id = "${aws_vpc.prodvpc.id}"
    
}


resource "aws_route_table" "prod-public-crt" {
    vpc_id = "${aws_vpc.prodvpc.id}"
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this IGW to reach internet
        gateway_id = "${aws_internet_gateway.prod-igw.id}" 
    }
    
    
}

resource "aws_route_table_association" "prod-crta-public-subnet-1"{
    subnet_id = "${aws_subnet.prodsubnetpublic1.id}"
    route_table_id = "${aws_route_table.prod-public-crt.id}"
}