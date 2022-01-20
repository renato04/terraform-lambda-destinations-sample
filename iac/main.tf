module "sns" {
    source = "./sns"
    aws_lambda_execution_role = var.aws_lambda_execution_role
    aws_account = var.aws_account    
}

module "sqs" {
    source = "./sqs"
    success_topic_arn = module.sns.success_topic_arn
}

module "origin_lambda" {
    source = "./lambda/origin_lambda"
    success_topic_arn = module.sns.success_topic_arn
    lambda_code_bucket_id = var.lambda_code_bucket_id
    aws_lambda_execution_role = var.aws_lambda_execution_role
    aws_account = var.aws_account
    depends_on = [
      module.sns
    ]
}

module "metadata_lambda" {
    source = "./lambda/metadata_test"
    lambda_code_bucket_id = var.lambda_code_bucket_id
    aws_lambda_execution_role = var.aws_lambda_execution_role
    aws_account = var.aws_account
    source_sqs = module.sqs.sqs_lambda_success_arn
    depends_on = [
      module.sns,
      module.sqs
    ]
}