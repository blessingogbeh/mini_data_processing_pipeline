terraform {
  required_version = "~> 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "boto3Layer" {
  source = "./modules/boto3_layer"

  path_to_boto3_layer_source   = local.path_to_boto3_layer_source
  path_to_boto3_layer_artifact = local.path_to_boto3_layer_artifact
  path_to_boto3_layer_filename = local.path_to_boto3_layer_filename
  boto3_layer_name             = local.boto3_layer_name
  compatible_layer_runtimes       = local.compatible_layer_runtimes
  compatible_architectures        = local.compatible_architectures
}

module "numpyLayer" {
  source = "./modules/numpy_layer"

  path_to_numpy_layer_source   = local.path_to_numpy_layer_source
  path_to_numpy_layer_artifact = local.path_to_numpy_layer_artifact
  path_to_numpy_layer_filename = local.path_to_numpy_layer_filename
  numpy_layer_name             = local.numpy_layer_name
  compatible_layer_runtimes       = local.compatible_layer_runtimes
  compatible_architectures        = local.compatible_architectures
}

module "pandasLayer" {
  source = "./modules/pandas_layer"

  path_to_pandas_layer_source   = local.path_to_pandas_layer_source
  path_to_pandas_layer_artifact = local.path_to_pandas_layer_artifact
  path_to_pandas_layer_filename = local.path_to_pandas_layer_filename
  pandas_layer_name             = local.pandas_layer_name
  compatible_layer_runtimes       = local.compatible_layer_runtimes
  compatible_architectures        = local.compatible_architectures
}



module "lambdaIAM" {
  source = "./modules/iam"

  lambda_iam_policy_name = local.lambda_iam_policy_name
  lambda_iam_policy_path = local.lambda_iam_policy_path
  lambda_iam_role_name   = local.lambda_iam_role_name
  lambda_iam_role_path   = local.lambda_iam_role_path
}

module "lambdaFunction" {
  source = "./modules/lambda"

  lambda_iam_role_arn = module.lambdaIAM.lambda_iam_role_arn
  path_to_source_file = local.path_to_source_file
  path_to_artifact    = local.path_to_artifact
  function_name       = local.function_name
  function_handler    = local.function_handler
  memory_size         = local.memory_size
  timeout             = local.timeout
  runtime             = local.runtime
  lambda_layer_arns   = [module.boto3Layer.boto3_layer_arn, module.pandasLayer.pandas_layer_arn, module.numpyLayer.numpy_layer_arn]
}