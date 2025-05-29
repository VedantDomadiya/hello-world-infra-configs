#*-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-*
#*-*-**-*-**-*-**-*-**-*-**VPC Variables**-*-**-*-**-*-**-*-**-*-**-*-*
#*-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-*
aws_region         = "ap-south-1"
project_name       = "hello-world"
environment        = "dev"
vpc_cidr_block     = "10.0.0.0/16"

vpc_public_subnets_config = {
  "public_az1" = { cidr_suffix = "0", az_index = 0, tags = { "NameSuffix" = "dev-az1" } },
  "public_az2" = { cidr_suffix = "1", az_index = 1, tags = { "NameSuffix" = "dev-az2" } }
}

vpc_private_subnets_config = {
  "private_az1" = { cidr_suffix = "2", az_index = 0, tags = { "NameSuffix" = "dev-az1-private" } },
  "private_az2" = { cidr_suffix = "3", az_index = 1, tags = { "NameSuffix" = "dev-az2-private" } }
  # Ensure cidr_suffixes for private subnets do not overlap with public ones
  # and are appropriate for your VPC's cidr_block and the newbits used in cidrsubnet (e.g., 8)
}

#*-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-*
#*-*-**-*-**-*-**-*-**-*-**RDS Variables**-*-**-*-**-*-**-*-**-*-**-*-*
#*-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-**-*-*
db_name                = "webappdb_dev"
db_username            = "devadmin"
db_instance_class      = "db.t3.micro"
db_allocated_storage   = 20
db_engine              = "postgres"
db_engine_version      = "17" # Example: check available versions for db.t3.micro in ap-south-1
db_port                = 5432

rds_custom_tags = {
  Owner       = "DevTeam"
  CostCenter  = "ProjectAlphaDev"
  DeployedBy  = "Terraform"
}

container_port = 80 // Note: container_image_tag is passed by workflow

enable_waf = true

waf_custom_ip_sets = {
  "allow_my_office" = {
    name               = "office-network-main"
    description        = "Allow traffic from main office IP"
    ip_address_version = "IPV4"
    addresses          = ["42.105.173.17/32", "103.228.144.150/32"] // Replace with real IP CIDR
    rule_action        = "allow"
    rule_priority      = 1 // Give this a low number to process it early
  },
  "block_test_ip" = {
    name               = "test-block-ip"
    description        = "Block a specific test IP"
    ip_address_version = "IPV4"
    addresses          = ["152.58.35.122/32"] // Replace with an IP you want to block
    rule_action        = "block"
    rule_priority      = 2
  }
  // Add more IP sets here as needed
}

waf_managed_rule_groups = [
  {
    name            = "AWSManagedRulesCommonRuleSet"
    priority        = 10
    vendor_name     = "AWS"
    override_action = "none"
  },
  {
    name            = "AWSManagedRulesAmazonIpReputationList"
    priority        = 20
    vendor_name     = "AWS"
  }
  # Add more managed rules here if needed
]

// Add any other variables that were previously defaulted in your .tf files