# Event source mapping for Lambda triggers

resource "aws_lambda_event_source_mapping" "kinesis_stream_trigger" {
  event_source_arn  = aws_kinesis_stream.data_stream.arn
  function_name     = aws_lambda_function.processing_lambda.arn
  starting_position = "LATEST"
}