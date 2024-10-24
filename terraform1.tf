# This aws_lambda_function is used when invoked with a local zipfile
resource "aws_lambda_function" "local_zipfile" {
  count = "${var.function_s3_bucket == "" ? 1 : 0}"

  # These are SPECIFIC to the deployment method:
  filename         = "${var.function_zipfile}"
  source_code_hash = "${var.function_s3_bucket == "" ? "${base64sha256(file("${var.function_zipfile}"))}" : ""}"

  # These are the SAME for both:
  description   = "${var.comment_prefix}${var.cronjob_name}"
  function_name = "${local.prefix_with_name}"
  handler       = "${var.function_handler}"
  runtime       = "${var.function_runtime}"
  timeout       = "${var.function_timeout}"
  memory_size   = "${var.memory_size}"
  role          = "${aws_iam_role.this.arn}"
  tags          = "${var.tags}"

  environment {
    variables = "${var.function_env_vars}"
  }
}

# This aws_lambda_function is used when invoked with a zipfile in S3
resource "aws_lambda_function" "s3_zipfile" {
  count = "${var.function_s3_bucket == "" ? 0 : 1}"

  # These are SPECIFIC to the deployment method:
  s3_bucket = "${var.function_s3_bucket}"
  s3_key    = "${var.function_zipfile}"

  # These are the SAME for both:
  description   = "${var.comment_prefix}${var.cronjob_name}"
  function_name = "${local.prefix_with_name}"
  handler       = "${var.function_handler}"
  runtime       = "${var.function_runtime}"
  timeout       = "${var.function_timeout}"
  memory_size   = "${var.memory_size}"
  role          = "${aws_iam_role.this.arn}"
  tags          = "${var.tags}"

  environment {
    variables = "${var.function_env_vars}"
  }
}

locals {
  function_arn        = "${element(concat(aws_lambda_function.local_zipfile.*.arn, list("")), 0)}${element(concat(aws_lambda_function.s3_zipfile.*.arn, list("")), 0)}"
  function_invoke_arn = "${element(concat(aws_lambda_function.local_zipfile.*.invoke_arn, list("")), 0)}${element(concat(aws_lambda_function.s3_zipfile.*.invoke_arn, list("")), 0)}"
}
