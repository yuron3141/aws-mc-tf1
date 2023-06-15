# start function
resource "aws_lambda_function" "mc_instance_start_lambda" {
  // Lambda関数の設定
  function_name = "start_mc_function"
  role = aws_iam_role.iam_for_lambda_mcEC2.arn

  filename = data.local_file.start_mc_archive.filename
  source_code_hash = filebase64sha256("${path.module}/deploy/start_mc_function.zip")
  timeout = 60

  handler = "start_mc_function.lambda_handler"
  runtime = "python3.9"

  environment {
    variables = {
      INSTANCE_ID = aws_instance.minecraft.id
    }
  }
}

# stop function
resource "aws_lambda_function" "mc_instance_stop_lambda" {
  // Lambda関数の設定
  function_name = "stop_mc_function"
  role = aws_iam_role.iam_for_lambda_mcEC2.arn

  filename = data.local_file.stop_mc_archive.filename
  source_code_hash = filebase64sha256("${path.module}/deploy/stop_mc_function.zip")
  timeout = 60

  handler = "stop_mc_function.lambda_handler"
  runtime = "python3.9"

  environment {
    variables = {
      INSTANCE_ID = aws_instance.minecraft.id
    }
  }
}