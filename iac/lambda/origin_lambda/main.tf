data "archive_file" "lambda_origin" {
  type = "zip"

  source_dir  = "${path.module}/../../../code/origin_lambda/src"
  output_path = "${path.module}/origin.zip"
}

resource "aws_s3_bucket_object" "lambda_origin" {
  bucket = var.lambda_code_bucket_id

  key = "lambdas/lambda_origin.zip"
  source = data.archive_file.lambda_origin.output_path

  etag = filemd5(data.archive_file.lambda_origin.output_path)
}

resource "aws_lambda_function" "origin" {
  function_name = "metadata-origin"

  s3_bucket = var.lambda_code_bucket_id
  s3_key    = aws_s3_bucket_object.lambda_origin.id

  runtime = "python3.8"
  handler = "lambda_handler.handle"

  source_code_hash = data.archive_file.lambda_origin.output_base64sha256

  role = "arn:aws:iam::${var.aws_account}:role/${var.aws_lambda_execution_role}"
}

resource "aws_lambda_function_event_invoke_config" "origin_destinations" {
    function_name = aws_lambda_function.origin.function_name
    qualifier     = "$LATEST"

    destination_config {
        on_success {
            destination = var.success_topic_arn
        }
    }
}