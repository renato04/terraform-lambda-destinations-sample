data "archive_file" "lambda_metadata" {
  type = "zip"

  source_dir  = "${path.module}/../../../code/metadata_test/src"
  output_path = "${path.module}/metadata.zip"
}

resource "aws_s3_bucket_object" "lambda_metadata" {
  bucket = var.lambda_code_bucket_id

  key = "lambdas/lambda_metadata.zip"
  source = data.archive_file.lambda_metadata.output_path

  etag = filemd5(data.archive_file.lambda_metadata.output_path)
}

resource "aws_lambda_function" "metadata" {
  function_name = "metadata-metadata"

  s3_bucket = var.lambda_code_bucket_id
  s3_key    = aws_s3_bucket_object.lambda_metadata.id

  runtime = "python3.8"
  handler = "lambda_handler.handle"

  source_code_hash = data.archive_file.lambda_metadata.output_base64sha256

  role = "arn:aws:iam::${var.aws_account}:role/${var.aws_lambda_execution_role}"
}

resource "aws_lambda_event_source_mapping" "metadata_sqs_mapping" {
  event_source_arn = var.source_sqs
  function_name    = aws_lambda_function.metadata.arn
}