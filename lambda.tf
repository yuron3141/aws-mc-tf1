# start function
resource "aws_lambda_function" "mc_instance_start_lambda" {
  // configure lambda function
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
# configure lambda function permisiion
resource "aws_lambda_permission" "start_lambda_perm" {
  statement_id  = "AllowCloudWatchEventsToInvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.mc_instance_start_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.mc_start_rule.arn
}

# stop function
resource "aws_lambda_function" "mc_instance_stop_lambda" {
  // configure lambda function
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
# configure lambda function permisiion
resource "aws_lambda_permission" "stop_lambda_perm" {
  statement_id  = "AllowCloudWatchEventsToInvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.mc_instance_stop_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.mc_stop_rule.arn
}