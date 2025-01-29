# Create the Kinesis Streams

resource "aws_kinesis_stream" "data_stream" {
  name             = "data_stream"
  shard_count      = 3
  retention_period = 24
  
  stream_mode_details {
    stream_mode = "PROVISIONED"
  }
}


# Event source mapping for Lambda triggers

resource "aws_lambda_event_source_mapping" "kinesis_stream_trigger" {
  event_source_arn  = aws_kinesis_stream.data_stream.arn
  function_name     = "data_processing"
  starting_position = "LATEST"
}

