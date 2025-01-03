# Create the Kinesis Streams

resource "aws_kinesis_stream" "data_stream" {
  count            = 3
  name             = var.aws_kinesis_stream_name[count.index]
  shard_count      = 1
  retention_period = 24
  
  stream_mode_details {
    stream_mode = "PROVISIONED"
  }
}
