provider "aws" {
    region = var.aws_region
    access_key = "your AWS Access key"
    secret_key = "your AWS secret key"
    token = "your AWS token"
}

data "archive_file" "lambda_file_zip" {
    type = "zip"
    source_file = "greet_lambda.py"
    output_path = var.lambda_output_zip_path
}

resource "aws_iam_role" "lambda_exec_role" {
    name = "lambda_exec_role"
    assume_role_policy = <<POLICY
{
        "Version": "2012-10-17",
         "Statement": [
           {
             "Action": "sts:AssumeRole",
             "Principal": {
             "Service": "lambda.amazonaws.com"
            },
             "Effect": "Allow",
             "Sid": ""
            }
        ]
    }
    POLICY
}

resource "aws_cloudwatch_log_group" "lambda_function_logs_group" {
    name = "/aws/lambda/${var.lambda_function_name}"
    retention_in_days = 7
}

resource "aws_iam_policy" "lambda_function_logs_policy" {
    name = "lambda_function_logs_policy"
    path = "/"
    policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
         "logs:CreateLogGroup",
         "Logs:CreateLogStream",
         "Logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
POLICY
}
resource "aws_iam_role_policy_attachment" "lambda_function_logs_policy"{
    role = aws_iam_role.lambda_exec_role.name
    policy_arn = aws_iam_policy.lambda_function_logs_policy.arn
}

resource "aws_lambda_function" "greet_lambda" {
    function_name = var.lambda_function_name
    filename = data.archive_file.lambda_file_zip.output_path
    source_code_hash = data.archive_file.lambda_file_zip.output_base64sha256
    handler = "greet_lambda.lambda_handler"
    runtime = "python3.8"
    role = aws_iam_role.lambda_exec_role.arn   
    environment{
        variables = {
          greeting = "Hello World from KT"
        }
    } 
    depends_on = [aws_iam_role_policy_attachment.lambda_function_logs_policy, aws_cloudwatch_log_group.lambda_function_logs_group]
}