terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../../modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  availability_zones   = ["ap-northeast-1a", "ap-northeast-1c"]
}

module "ecs" {
  source = "../../modules/ecs"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  sqs_queue_arn         = module.sqs.queue_arn
  db_secret_arn         = module.rds.secret_arn
  xray_policy_arn       = module.xray.xray_policy_arn
  private_subnet_ids    = module.vpc.private_subnet_ids
  ecr_product_image_uri = module.ecr.repository_urls["product"]
  ecr_order_image_uri   = module.ecr.repository_urls["order"]
}

module "ecr" {
  source = "../../modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}

module "rds" {
  source = "../../modules/rds"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  ecs_security_group_id = module.ecs.security_group_id
}

module "dynamodb" {
  source = "../../modules/dynamodb"

  project_name = var.project_name
  environment  = var.environment
}

module "sqs" {
  source = "../../modules/sqs"

  project_name = var.project_name
  environment  = var.environment
}

module "api_gateway" {
  source = "../../modules/api_gateway"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "lambda" {
  source = "../../modules/lambda"

  project_name       = var.project_name
  environment        = var.environment
  sqs_queue_arn      = module.sqs.queue_arn
  dynamodb_table_arn = module.dynamodb.notification_history_table_arn
  ecr_image_uri      = "${module.ecr.repository_urls["notification"]}:latest"
}

module "cloudwatch" {
  source = "../../modules/cloudwatch"

  project_name      = var.project_name
  environment       = var.environment
  slack_webhook_url = var.slack_webhook_url
}

module "waf" {
  source = "../../modules/waf"

  project_name = var.project_name
  environment  = var.environment
}

module "codedeploy" {
  source = "../../modules/codedeploy"

  project_name     = var.project_name
  environment      = var.environment
  ecs_cluster_name = module.ecs.cluster_name
}

module "xray" {
  source = "../../modules/xray"

  project_name = var.project_name
  environment  = var.environment
}

# WAF → API Gateway紐付け(WAFをAPI Gatewayにassociationする)
resource "aws_wafv2_web_acl_association" "main" {
  resource_arn = module.api_gateway.api_arn
  web_acl_arn  = module.waf.web_acl_arn
}

