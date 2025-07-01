terraform-eks

A repository to create an EKS cluster on AWS using Terraform.

####Install AWS CLI

Install the AWS CLI, as we will use the aws configure command to connect Terraform with AWS.

Follow the link below to install the AWS CLI:

https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

####Install Terraform

Install Terraform using the link below:

https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

####Install kubectl

Install kubectl using the link below:

https://kubernetes.io/docs/tasks/tools/

####Create an AWS IAM User

Go to IAM > Users > Create user

Attach the following policy directly:

IAMFullAccess

##Create an inline policy for the user:

Go to: IAM > Users > [aws_username] > Create policy > JSON tab

Paste the updated JSON policy and save it.

{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"ec2:*",
				"logs:*",
				"iam:*",
				"kms:*",
				"eks:*",
				"s3:*"
				"autoscaling:*"
			],
			"Resource": "*"
		}
	]
}

#####Create Access Keys


Navigate to: IAM > Users > [aws_username] > Security credentials > Create access key

Save the Access key ID and Secret access key in a secure place (e.g., Notepad or a password manager) for future use.

###Connect Terraform with AWS

Run the following command and enter your AWS credentials when prompted:

###aws configure

This command links Terraform to your AWS account using the provided credentials.

###Clone the repository.

Run

#git clone https://github.com/Martin-Raju/eks-terraform.git



###Create S3 bucket for statefile

Navigate into the project directory (\eks-terraform\Terraform\global).
update bucket name in s3bucket.tf
Run:

#terraform init
#terraform plan
#terraform apply --auto-approve

##update all  values in the terraform.tfvars file

kubernetes_version = 
vpc_cidr = 
aws_region = 
cluster_name = 
environment = 
bucket_name = 
aws_acc_id = 
aws_user_name = 

#####create cluster

Navigate into the project directory (eks-terraform\Terraform\environments\dev or stage or prod).

Run:

#terraform init
#terraform plan
#terraform apply --auto-approve

Confirm the prompt to proceed. Terraform will begin provisioning the resources as defined in the configuration.

####verify cluster access
Run:
#aws eks --region <region> update-kubeconfig --name <cluster_name>

#update cluster node group policies

Navigate to:

Amazon EKS > Clusters > dev-poc-cluster > [node_group-name] > Node IAM role ARN > Permissions policies > Create inline policy (JSON)

Add the following policy:


{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"autoscaling:DescribeAutoScalingGroups",
				"autoscaling:DescribeAutoScalingInstances",
				"autoscaling:DescribeLaunchConfigurations",
				"autoscaling:DescribeTags",
				"autoscaling:SetDesiredCapacity",
				"autoscaling:TerminateInstanceInAutoScalingGroup"
			],
			"Resource": "*"
		},
		{
			"Effect": "Allow",
			"Action": [
				"ec2:DescribeLaunchTemplateVersions",
				"ec2:DescribeInstanceTypes",
				"ec2:DescribeInstances",
				"ec2:DescribeImages",
				"ec2:DescribeSubnets",
				"ec2:DescribeSecurityGroups",
				"ec2:DescribeAvailabilityZones",
				"ec2:DescribeTags"
			],
			"Resource": "*"
		}
	]
}

#####Install Metrics Server
Run:
#kubectl apply -f Kubernetes/global/metrics.yml

#In Kubernetes/global/cluster-autoscaler.yaml, update <cluster-name>

  - --node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/<cluster-name>

#####Install Cluster-Autoscaler
Run:
#kubectl apply -f Kubernetes/global/cluster-autoscaler.yaml

####Verify installation
Run:
 #kubectl -n kube-system logs -f deployment/cluster-autoscaler
 #kubectl get pods -A


###########EKS Scaling Demonstration(HPA and cluster-autoscale)################


#####Deploy a Sample Application
Run:
#kubectl apply -f Kubernetes/HPA/sampleapp.yml

#####Deploy a Sample service
Run:
#kubectl apply -f Kubernetes/HPA/sampleappservice.yml

####Deploy Horizontal Pod Autoscaler (HPA)
Run:
#kubectl apply -f Kubernetes/HPA/hpa.yml

######Verify the pod/node counts 
Run:
#kubectl get pods 
#kubectl get nodes

######start a container and send an infinite loop of queries to the ‘php-apache’ service, listening on port 8080
open new terminal and run:
#kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://hpa-demo-deployment; done"

###Observe Pods and Nodes Scaling 
As CPU usage exceeds 50%, pods and nodes will scale up.
Run:
#kubectl get pods
#kubectl get nodes
#kubectl -n kube-system logs -f deployment/cluster-autoscaler

####Scale Down Pods and Nodes

Stop the load generator using CTRL+C.
As CPU usage decreases, pods and nodes will scale down automatically

Run:
#kubectl get pods
#kubectl get nodes
#kubectl -n kube-system logs -f deployment/cluster-autoscaler

####Clean Up 
Run:
#kubectl delete -f Kubernetes/HPA/sampleapp.yml
#kubectl delete -f Kubernetes/HPA/hpa.yml
#kubectl delete -f Kubernetes/HPA/sampleappservice.yml
#kubectl delete -f Kubernetes/global/metrics.yml
#kubectl delete -f Kubernetes/global/cluster-autoscaler.yml
cd Terraform/env
#terraform destroy --auto-approve
