## Experiment Broker
This is the main module of Experiment Broker, containing the actions and probes that make up experiments.

## Creating Actions and Probes

Actions and probes are the way that an experiment is able to both induce failure in the environment and get information from the environment. 
* **Actions**:  Python functions referenced by experiments which either induce failure or have some sort of effect on the environment. 
* **Probes**: Python functions which retrieve information from the environment.


Imagine a new experiment is written to stress all network I/O. The experiment will need to reference an action to accomplish this failure. The YAML code referencing the action in the experiment is shown here:
```YAML
type: action
    name: black_hole_network
    provider:
      type: python
      module: activities.ec2.actions
      func: stress_all_network_io
      arguments:
        test_target_type: 'RANDOM'
        tag_key: 'tag:Name'
        tag_value: 'node_value'
        region: 'us-east-1'
        duration: '60'
```
Under `module`, the experiment refers to `activities.ec2.actions`. This tells us the corresponding action is referencing the `actions.py` file under the **activities/ec2/** directory, as discussed in the folder structure section above. That is where the code for all ec2 actions are written. 
<pre>
activities
 ┣ <b>ec2</b>
 ┃ ┣ __init__.py
 ┃ ┣ <b>actions.py</b>
 ┃ ┗ shared.py
 </pre>

Many custom functions are required to have these arguments: 
 * `test_target_type` :  'ALL' or 'RANDOM'. Determines if the action/probe is run on 1 randomly selected instance or all instances.
 * `test_target_key`  :  'tag:Name'. The tag key of the tag used to identify the instance(s) the action/probe is run on.
 * `test_target_value` : The tage value used to identify the instance(s) to run the action/probe on.
 
Actions which require command line utilities such as `stress-ng` or `tc` will require the use of an SSM document. For the Stress Network I/O function, we will need a duration of time for the failure to take place. Since this action will require the use of a command line utility, we will use an SSM document in this example. The function header for our Stress Network I/O function will look like this: 

 ```Python
 def stress_all_network_io(targets: List[str] = None,
							   test_target_type: str ='RANDOM',
							   tag_key: str = None, 
							   tag_value: str = None, 
				  			   region: str = 'us-east-1',
							   duration: str = None):
```

The first step of the function is to identify the EC2 instance on which the test will run. This requires the use of a shared function, `get_test_instance_ids`. This is where we will use the arguments passed to the function. In order to use this function, you must make sure to import the function to the `actions.py` file.
```python
from activities.ec2.shared import get_test_instance_ids
```
We can then call the function using the arguments passed into the function such as the `tag_key`, `tag_value`, and `test_target_type`. `tag_key` is a tag key such as "tag:Name", and `tag_value` refers to the value associated with that key. The `test_target_type` parameter determines if the function returns 1 random instance-id or all instance-ids associated with that tag. These parameters are passed from the experiment.
```python
test_instance_ids = get_test_instance_ids(test_target_type = test_target_type, tag_key = tag_key, tag_value = tag_value)
```
Next, we set the parameters required for the SSM document. 
```python
parameters = {'duration': [duration,]}
```
Since we are using a command line utility to complete this action, this action calls an SSM document, "StressAllNetworkIO". This is done via [boto3](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html). First we create a boto3 ssm client, then use that ssm client to issue a Systems Manager `runCommand` using the SSM Document  "StressAllNetworkIO". Then, we use the boto3 `send_command` function to run our commands. 
Some of the parameters sent via boto3:
* `DocumentName`: The name of the SSM document which to run
* `InstanceIds`: the instance-ids of the instance too run the commands on.
* `CloudwatchOutputConfig`: Determines if the output is sent to CloudWatch for monitoring purposes.
* `OutputS3BucketName`: Gives the name of the S3 bucket used for SSM stdout. For monitoring purposes like CloudWatch
* `Parameters`: This is the list of parameters to be sent to the SSM document being run by this function. These parameters were set in the last step. 
 
We also attempt to catch any ClientErrors returned by the boto3 function call. 
```python
session = boto3.Session()
ssm = session.client('ssm', region)
	try:
		response = ssm.send_command(DocumentName = "StressAllNetworkIO",
									InstanceIds = test_instance_ids,
									CloudWatchOutputConfig = {
                                		'CloudWatchOutputEnabled':True
                                    },
                                    OutputS3BucketName = 'experiment-ssm-command-output'
									Parameters = parameters)
	except ClientError as e:
		logging.error(e)
		raise
return response
```

We then return the response from boto3 as the result of the action. This concludes the body of the function. We have now written our first action to go along with an experiment! Please refer to [Resiliency Testing Experiments](https://github.com/VerticalRelevance/resiliency-framework-experiments.git) repository to learn about Experiment creation in YAML.