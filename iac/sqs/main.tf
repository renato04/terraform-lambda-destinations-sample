resource "aws_sqs_queue" "lambda_success_dl" {
    name = "lambda_success_queue_dl"
  
}

resource "aws_sqs_queue" "lambda_success" {
    name = "lambda_success_queue"
        redrive_policy = jsonencode({
            deadLetterTargetArn = aws_sqs_queue.lambda_success_dl.arn
            maxReceiveCount     = 4
     })
  
}

resource "aws_sns_topic_subscription" "lambda_success_subscription" {
  topic_arn = var.success_topic_arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.lambda_success.arn
}

resource "aws_sqs_queue_policy" "lambda_success_allow_sns" {
    queue_url = "${aws_sqs_queue.lambda_success.id}"

    policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.lambda_success.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${var.success_topic_arn}"
        }
      }
    }
  ]
}
POLICY
}