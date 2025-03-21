environment_id                       = "default"
repository_id                        = "VerticalRelevance/Experiment-Broker-Internal-Private"
repository_branch                    = "main"
experiments_bucket_name              = "experiment-broker-experiments-bucket"
experiment_results_bucket_name       = "experiment-broker-experiment-results-bucket"
package_build_bucket_name            = "experiment-broker-package-build-bucket"
build_pipeline_name                  = "experiment-broker-build-pipeline"
destroy_pipeline_name                = "experiment-broker-build-cleanup-pipeline"
terraform_version                    = "1.10.3"
artifact_bucket_name                 = "experiment-broker-codepipeline-artifacts-bucket"
codestar_connection_name             = "experiment-broker-connection"
build_plan_name                      = "experiment-broker-build-tf-plan"
build_apply_name                     = "experiment-broker-build-tf-apply"
build_plan_destroy_name              = "experiment-broker-build-tf-plan-destroy"
build_apply_destroy_name             = "experiment-broker-build-tf-apply-destroy"
codebuild_cloudwatch_log_group_name  = "/experiment-broker/codepipeline"
codebuild_cloudwatch_log_stream_name = "/build"
sfn_lambda_name                      = "experiment-broker-lambda"
sfn_lambda_log_level                 = "INFO"
sfn_lambda_state_machine_name        = "experiment-broker-state-machine"
sfn_cloudwatch_log_group_name        = "/aws/vendedlogs/experiment-broker/sfn"
s3_key_alias                         = "alias/experiment-broker-s3-key"
s3_key_description                   = "KMS key for encrypting the S3 bucket."
experiment_broker_deployment_type    = "lambda"
chaos_toolkit_type                   = "main"