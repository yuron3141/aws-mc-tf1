# Trigger is every day JPT 15:00
resource "aws_cloudwatch_event_rule" "mc_start_rule" {
  name        = "mc-start-rule"
  description = "Start EC2 every day 15:00 in JPT"

  schedule_expression = "cron(0 7 * * ? *)"
  
}

# Configure CloudWatch event target
resource "aws_cloudwatch_event_target" "mc_start_event_target" {
  rule = aws_cloudwatch_event_rule.mc_start_rule.name
  target_id = aws_lambda_function.mc_instance_start_lambda.function_name
  arn  = aws_lambda_function.mc_instance_start_lambda.arn
}

# Trigger is every day JPT 22:00
resource "aws_cloudwatch_event_rule" "mc_stop_rule" {
  name        = "mc-stop-rule"
  description = "Start EC2 every day 22:00 in JPT"

  schedule_expression = "cron(0 13 * * ? *)"

}
# Configure CloudWatch event target
resource "aws_cloudwatch_event_target" "mc_stop_event_target" {
  rule = aws_cloudwatch_event_rule.mc_stop_rule.name
  target_id = aws_lambda_function.mc_instance_stop_lambda.function_name
  arn  = aws_lambda_function.mc_instance_stop_lambda.arn
}