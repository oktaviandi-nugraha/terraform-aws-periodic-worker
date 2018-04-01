provider "aws" {
  region = "ap-southeast-1"
}

module "periodic_worker" {
  source = "../"

  lambda_code_bucket = "tools-infra-lambda-bucket"

  lambda_code_path = "dummy.zip"

  lambda_name = "alambda"

  lambda_runtime = "nodejs6.10"

  lambda_handler = "lib.default"

  lambda_memory_size = "128"

  lambda_timeout = "300"

  tags = {
    "team"   = "someteam"
    "domain" = "somedomain"
  }

  schedule_expression = "cron(*/2 * * * ? *)"

  iam_policy_document = ""
}
