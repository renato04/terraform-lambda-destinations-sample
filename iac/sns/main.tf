resource "aws_sns_topic" "success" {
  name = "lambda_success"
}


# resource "aws_sns_topic_policy" "success_default" {
#   arn = aws_sns_topic.success.arn

#   policy = data.aws_iam_policy_document.sns_topic_policy.json
# }

# data "aws_iam_policy_document" "sns_topic_policy" {
#   policy_id = "__default_policy_ID"

#   statement {
#     actions = [
#       "SNS:Subscribe",
#       "SNS:SetTopicAttributes",
#       "SNS:RemovePermission",
#       "SNS:Receive",
#       "SNS:Publish",
#       "SNS:ListSubscriptionsByTopic",
#       "SNS:GetTopicAttributes",
#       "SNS:DeleteTopic",
#       "SNS:AddPermission",
#     ]

#     condition {
#       test     = "StringEquals"
#       variable = "AWS:SourceOwner"

#       values = [
#         var.aws_account,
#       ]
#     }

#     effect = "Allow"

#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }

#     resources = [
#       aws_sns_topic.success.arn,
#     ]

#     sid = "__default_statement_ID"
#   }
# }

# data "aws_iam_policy_document" "sns_topic_policy" {
#   policy_id = "execution_lambda_policy"

#   statement {
#     actions = [
#       "SNS:Publish",
#     ]

#     effect = "Allow"
#     resources = [
#       "arn:aws:iam::${var.aws_account}:role/${var.aws_lambda_execution_role}",
#     ]

#     sid = "execution_lambda_policy_id"
#   }

#   statement {
#     actions = [
#         "SNS:GetTopicAttributes",
#         "SNS:SetTopicAttributes",
#         "SNS:AddPermission",
#         "SNS:RemovePermission",
#         "SNS:DeleteTopic",
#         "SNS:Subscribe",
#         "SNS:ListSubscriptionsByTopic",
#         "SNS:Publish"
#     ]
#     effect = "Allow"
#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }
#     resources = [
#       "arn:aws:sns:us-east-1:${var.aws_account}:${aws_sns_topic.success.name}"
#     ]
#     condition  {
#       test = "StringEquals"
#       variable = "AWS:SourceOwner"
#       values = [
#         "${var.aws_account}"
#       ]
#     }

#     sid = "_default_statement_ID"
#   }
# }