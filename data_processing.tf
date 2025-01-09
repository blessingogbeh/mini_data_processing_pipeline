
# Archive a processing.py into a zip file
locals {
  lambda_processing_function = "processing_func/package.zip"
}


# Upload Lambda zip to S3
resource "aws_s3_object" "lambda_processing" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "package.zip"
  source = local.lambda_processing_function
  etag   = filemd5(local.lambda_processing_function)
}


# Create the Lambda Function for processing the data
resource "aws_lambda_function" "processing_lambda" {
  #filename      = local.lambda_processing_location
  function_name = "data-processing"
  role          = aws_iam_role.lambda_role.arn
  handler       = "data-processing.lambda_handler"

  s3_bucket         = aws_s3_bucket.lambda_bucket.id
  s3_key            = aws_s3_object.lambda_processing.key
  s3_object_version = aws_s3_object.lambda_processing.version_id

  source_code_hash = filebase64sha256(local.lambda_processing_function)

  runtime = "python3.9"

  environment {
    variables = {
      WEATHER_TABLE       = "weather_data"
      BUS_TABLE           = "bus_location_data"
      VAN_TABLE           = "van_location_data"
      PASSENGER_THRESHOLD = 50
      DELAY_THRESHOLD     = 300
      DATA_STREAM         = aws_kinesis_stream.data_stream.name
      #VAN_STREAM          = aws_kinesis_stream.data_stream[0].name
      #BUS_STREAM          = aws_kinesis_stream.data_stream[1].name
      #WEATHER_STREAM      = aws_kinesis_stream.data_stream[2].name
    }
  }

  depends_on = [aws_iam_role_policy.lambda_policy]

}

# Event source mapping for Lambda triggers
resource "aws_lambda_event_source_mapping" "van_location_trigger" {
  event_source_arn  = aws_kinesis_stream.data_stream.arn
  function_name     = aws_lambda_function.processing_lambda.arn
  starting_position = "LATEST"
}
/*
resource "aws_lambda_event_source_mapping" "weather_trigger" {
  event_source_arn  = aws_kinesis_stream.data_stream[1].arn
  function_name     = aws_lambda_function.processing_lambda.arn
  starting_position = "LATEST"
}

resource "aws_lambda_event_source_mapping" "bus_location_trigger" {
  event_source_arn  = aws_kinesis_stream.data_stream[2].arn
  function_name     = aws_lambda_function.processing_lambda.arn
  starting_position = "LATEST"
}
*/