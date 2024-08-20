# VPC, subnets and security groups configuration
1. Custom vpc with cidr passed as a variable defaults to (10.0.0.0/16)
2. 2 Availability zones in preffered region (also a variable)
3. 4 Public and Private subnet in each AZ - subnet cidrs passed as variable determine the number of created subnets
4. Route table with associated subnets and gateways
5. Public, Private and EFS security group with relevant permissions
6. Internet and Nat GW