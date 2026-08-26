resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { 
    Name = "main-vpc" 
    }
}



resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags                    = { 
    Name = "public-subnet-az1"
     }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags                    = {
     Name = "public-subnet-az2"
      }
}


resource "aws_subnet" "private_app_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "us-east-1a"
  tags              = { 
    Name = "private-app-subnet-az1"
     }
}

resource "aws_subnet" "private_app_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "us-east-1b"
  tags              = {
     Name = "private-app-subnet-az2"
      }
}


resource "aws_subnet" "private_db_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.21.0/24"
  availability_zone = "us-east-1a"
  tags              = { 
    Name = "private-db-subnet-az1"
     }
}

resource "aws_subnet" "private_db_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.22.0/24"
  availability_zone = "us-east-1b"
  tags              = {
    
     Name = "private-db-subnet-az2" 
     }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags   = {
     Name = "main-igw" 
     }
}

resource "aws_eip" "nat_1" {
    domain ="vpc"
  
}

resource "aws_eip" "nat_2" {
    domain = "vpc"

}

resource "aws_nat_gateway" "nat_1" {
    allocation_id = aws_eip.nat_1.id
    subnet_id = aws_subnet.public_1.id
    tags = {
      Name="nat-gateway-az1"
    }
  
}


resource "aws_nat_gateway" "nat_2" {
    allocation_id = aws_eip.nat_2.id
    subnet_id = aws_subnet.public_2.id
    tags = {
      Name="nat-gateway-az2"
    }
  
}


resource "aws_route_table" "MRT" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-route-table"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.MRT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}


resource "aws_route_table" "CRT_1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-route-table-1"
  }
}

resource "aws_route" "private_nat_1" {
  route_table_id         = aws_route_table.CRT_1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_1.id
}

resource "aws_route_table" "CRT_2" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-route-table-1"
  }
}

resource "aws_route" "private_nat_2" {
  route_table_id         = aws_route_table.CRT_2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_2.id
}


resource "aws_route_table_association" "pub_1" {
    subnet_id = aws_subnet.public_1.id
    route_table_id = aws_route_table.MRT.id

}

resource "aws_route_table_association" "pub_1" {
    subnet_id = aws_subnet.public_1.id
    route_table_id = aws_route_table.MRT.id

}


resource "aws_route_table_association" "pub_2" {
    subnet_id = aws_subnet.public_2.id
    route_table_id = aws_route_table.MRT.id

}

resource "aws_route_table_association" "private_app1" {
    subnet_id = aws_subnet.private_app_1.id
    route_table_id = aws_route_table.CRT_1.id
  
}


resource "aws_route_table_association" "private_app2" {
    subnet_id = aws_subnet.private_app_2.id
    route_table_id = aws_route_table.CRT_2.id
  
}








