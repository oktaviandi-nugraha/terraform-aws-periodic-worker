# Scheduled AWS Lambda function
=============================

This module is used to provision AWS Lambda outside VPC to run on a schedule. This will create:
- One CloudWatchEvent
- Lambda function
- IAM Role assigned to the lambda with the following policies attached: AWSLambdaBasicExecutionRole. You could add other policy that the lambda needs.

Module Input Variables
----------------------

- `region` - Region where the lambda is deployed. The default is ap-southeast-1
- `lambda_code_bucket` - The name of the s3 bucket where the deployment resides
- `lambda_code_path` - Name of the S3 deployment object
- `lambda_name` - Unique name for Lambda function
- `lambda_runtime` - A [valid](http://docs.aws.amazon.com/cli/latest/reference/lambda/create-function.html#options) Lambda runtime environment
- `lambda_handler` - The entrypoint into your Lambda function
- `lambda_memory_size` - The memory size allocated to your lambda function
- `tags` - Tags associated with the lambda function
- `environment_variables` - Environment variables for your lambda function
- `iam_policy_document` - Additional IAM policy document to be attached to your lambda if the lambda needs to access another AWS resource.
- `schedule_expression` - a [valid rate or cron expression](http://docs.aws.amazon.com/lambda/latest/dg/tutorial-scheduled-events-schedule-expressions.html)

Usage 
-----

```js
data "aws_iam_policy_document" "read-a-bucket" {
  statement {
    sid    = "AllowReadOfABucket"
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::public-bucket/*",
    ]
  }
}

module "periodic_worker" {
  source = "git::ssh://git@git.traveloka.com/terraform-aws-periodic-worker-vpc.git?ref=[version]"

  lambda_code_bucket = "tools-infra-lambda-bucket"

  lambda_code_path = "dummy.zip"

  lambda_name = "alambda"

  lambda_runtime = "nodejs6.10"

  lambda_handler = "lib.default"

  lambda_memory_size = "128"

  lambda_timeout = "300"

  require_additional_policy = true

  tags = {
    "team"   = "someteam"
    "domain" = "somedomain"
  }

  schedule_expression = "cron(*/10 * * * ? *)"

  iam_policy_document = "${data.aws_iam_policy_document.read-a-bucket.json}"
}
```

Outputs
-------
- `lambda_arn` - ARN for the created Lambda function
- `role_arn` - ARN of the IAM role assigned to the lambda

Author
------
Created and maintained by [Oktaviandi Hadi Nugraha](https://github.com/oktaviandi-nugraha)
