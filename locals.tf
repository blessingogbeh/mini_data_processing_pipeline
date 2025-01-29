locals {
  lambda_iam_policy_name = "lambda_iam_policy"
  lambda_iam_policy_path = "./modules/iam/lambda-iam-policy.json"
  lambda_iam_role_name   = "lambda_iam_role"
  lambda_iam_role_path   = "./modules/iam/lambda-assume-role-policy.json"

  path_to_boto3_layer_source   = "./boto3"
  path_to_boto3_layer_artifact = "./artifacts/boto3.zip"
  path_to_boto3_layer_filename = "./artifacts/boto3.zip"
  boto3_layer_name             = "boto3"

  path_to_numpy_layer_source   = "./numpy"
  path_to_numpy_layer_artifact = "./artifacts/numpy.zip"
  path_to_numpy_layer_filename = "./artifacts/numpy.zip"
  numpy_layer_name             = "numpy"

  path_to_pandas_layer_source   = "./pandas"
  path_to_pandas_layer_artifact = "./artifacts/pandas.zip"
  path_to_pandas_layer_filename = "./artifacts/pandas.zip"
  pandas_layer_name             = "pandas"

  compatible_layer_runtimes = ["python3.11"]
  compatible_architectures  = ["x86_64"]

  path_to_source_file = "./src/data-processing.py"
  path_to_artifact    = "./artifacts/data_processing.zip"
  function_name       = "data_processing"
  function_handler    = "data-processing.lambda_handler"
  memory_size         = 512
  timeout             = 300
  runtime             = "python3.11"
}