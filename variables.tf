#declaring variables

variable "aws_kinesis_stream_name" {
  description = "The name of the Kinesis stream"
  default     = ["bus-location-stream", "van-location-stream", "weather-stream"]
}