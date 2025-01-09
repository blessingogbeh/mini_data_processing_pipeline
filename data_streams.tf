# Create the Kinesis Streams

resource "aws_kinesis_stream" "data_stream" {
  name             = "data_stream"
  shard_count      = 3
  retention_period = 24
  
  stream_mode_details {
    stream_mode = "PROVISIONED"
  }
}
