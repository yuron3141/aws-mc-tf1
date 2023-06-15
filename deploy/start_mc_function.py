import boto3

def lambda_handler(event, context):
    ec2 = boto3.client("ec2")
    
    # 起動させるインスタンスのIDを指定
    instance_id = 'i-XXXXXXXXXXXXXXXXX'

    try:
        response = ec2.start_instances(InstanceIds=[instance_id])
        print(f"Instance {instance_id} is starting")
    except Exception as e:
        print(f"Error starting instance {instance_id}: {str(e)}")
        raise