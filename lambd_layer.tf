#create a lambda to carry lambda function dependencies


resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "lambda_layer.zip"
  layer_name = "dependencies"

  compatible_runtimes = ["python3.11"]
}