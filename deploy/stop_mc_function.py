import boto3

def lambda_handler(event, context):
    ec2 = boto3.client("ec2")
    
    # 停止させるインスタンスのIDを指定
    instance_id = 'i-XXXXXXXXXXXXXXXXX'

    try:
        response = ec2.stop_instances(InstanceIds=[instance_id])
        print(f"Instance {instance_id} is stoping")
    except Exception as e:
        print(f"Error stoping instance {instance_id}: {str(e)}")
        raise