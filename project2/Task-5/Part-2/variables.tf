# TODO: Define the variable for aws_region
variable "aws_region" {
    default = "us-east-1"
}

variable "lambda_output_zip_path"{
    default = "output.zip"
}

variable "lambda_function_name"{
    default = "greet_lambda"
}