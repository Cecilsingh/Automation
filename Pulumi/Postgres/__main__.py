#Import Pulumi packages
import pulumi
import pulumi_aws as aws

#Specify key pair
deployer = aws.ec2.KeyPair("deployer", public_key="REDACTED">

#Create a new security group
#In this case, we are allowing SSH traffic to the server
sg = aws.ec2.SecurityGroup(
    "dbcreate-sg",
     description="Database security group",
        ingress = [
        {
                'protocol': 'tcp',
                'from_port': 22,
                'to_port': 22,
                'cidr_blocks': ['REDACTED']
        }
      ]
)

#Specify the AMI
#In this case, we use Amazon Linux most recent AMI
ami = aws.ec2.Ami("createdb",
    ebs_block_devices=[aws.ec2.AmiEbsBlockDeviceArgs(
        device_name="/dev/sda1",
        snapshot_id="REDACTED",
        volume_size=12,
    )],
    root_device_name="/dev/sda1",
    virtualization_type="hvm")

#Specify the instance details
#In this case, we use a t2.micro instance
instance = aws.ec2.Instance(
    "Pulumi-dbapp",
    instance_type="t2.micro",
    security_groups=[sg.name],
    ami = ami.id,
    key_name = deployer,
)
