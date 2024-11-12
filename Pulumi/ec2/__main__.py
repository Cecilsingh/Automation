#Import Pulumi
import pulumi
import pulumi_aws as aws

#Create a new security group
#In this case, we are allowing HTTP traffic to our server
sg = aws.ec2.SecurityGroup(
    "REDACTED",
     description="web application security group",
        ingress = [
        {
                'protocol': 'tcp',
                'from_port': 80,
                'to_port': 80,
                'cidr_blocks': ['REDACTED']

        }
      ]
)

#Specify the AMI
#In this case, we use Amazon Linux most recent AMI
ami = aws.get_ami(
        most_recent="true",
        owners=['amazon'],
        filters=[{'name': 'name', 'values': ['amzn-ami-hvm-*']}]
)

#Create a simple HTTP server
user_data="""
#!/nim/bash
uname -n > index.html
nohup python -m SimpleHTTPServer 80 &
"""

#Specify the instance details
#In this case, we use a t2.micro instance
instance = aws.ec2.Instance(
    "Pulumi-webapp",
    instance_type="t2.micro",
    security_groups=[sg.name],
    ami = ami.id,
    user_data=user_data,
)

#Show the IP address of the server when you access the web application
pulumi.export("web-app-ip", instance.public_ip)
