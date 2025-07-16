#Terraform EKS

This repository provisions an EKS (Elastic Kubernetes Service) cluster on AWS using Terraform.

##Prerequisites

###Install AWS CLI

Follow the official AWS documentation to install the AWS CLI:

https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

###Install Terraform

Install Terraform using the official guide:

https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

###Install kubectl

Install kubectl using the official Kubernetes documentation:

https://kubernetes.io/docs/tasks/tools/

###Create an AWS IAM User

Go to IAM > Users > Create user

Attach the following policy directly:

 IAMFullAccess

###Create an inline policy for the user:

Go to Go to IAM > Users > [your_username] > Add permissions > Create inline policy

Open the JSON tab and paste the following policy:

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
				"s3:*",
				"autoscaling:*",
				"elasticloadbalancing:*
			],
			"Resource": "*"
		}
	]
}

###Create Access Keys

Navigate to IAM > Users > [your_username] > Security credentials > Create access key

Save the Access Key ID and Secret Access Key securely.

##Connect Terraform with AWS

Run the following command and enter your AWS credentials when prompted:

##aws configure

This command links Terraform to your AWS account using the provided credentials.

##Clone the repository.

Run

git clone https://github.com/Martin-Raju/eks-terraform.git

##Create S3 bucket for statefile

Navigate into the project directory (\eks-terraform\Terraform\global).
update bucket name in s3bucket.tf
Run:

terraform init
terraform plan
terraform apply --auto-approve

##update all  values in the terraform.tfvars file

kubernetes_version = 
vpc_cidr = 
aws_region = 
cluster_name = 
environment = 
bucket_name = 
aws_acc_id = 
aws_user_name =
private_subnets =
public_subnets =
 
##create cluster

Navigate into the project directory (eks-terraform\Terraform\env.

Run:

terraform init
terraform plan
terraform apply --auto-approve

Confirm the prompt to proceed. Terraform will begin provisioning the resources as defined in the configuration.

##verify cluster access

Run:
aws eks --region <region> update-kubeconfig --name <cluster_name>

##Install Metrics Server

Run:
kubectl apply -f Kubernetes/global/metrics.yml

## update <cluster-name>

In Kubernetes/global/cluster-autoscaler.yaml,

  - --node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/<cluster-name>

##Install Cluster-Autoscaler

Run:
kubectl apply -f Kubernetes/global/cluster-autoscaler.yaml

####Verify installation

Run:
kubectl -n kube-system logs -f deployment/cluster-autoscaler
kubectl get pods -A

##EKS Scaling Demonstration(HPA and cluster-autoscale)

###Deploy a Sample Application

Run:
kubectl apply -f Kubernetes/HPA/sampleapp.yml

###Deploy a Sample service
Run:
kubectl apply -f Kubernetes/HPA/sampleappservice.yml

###Deploy Horizontal Pod Autoscaler (HPA)
Run:
kubectl apply -f Kubernetes/HPA/hpa.yml

###Verify the pod/node counts 
Run:
kubectl get pods 
kubectl get nodes

###start a container and send an infinite loop of queries to the ‘php-apache’ service, listening on port 8080

open new terminal and run:
kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://hpa-demo-deployment; done"

###Observe Pods and Nodes Scaling 

As CPU usage exceeds 50%, pods and nodes will scale up.

Run:
kubectl get pods
kubectl get nodes
kubectl -n kube-system logs -f deployment/cluster-autoscaler

###Scale Down Pods and Nodes

Stop the load generator using CTRL+C.
As CPU usage decreases, pods and nodes will scale down automatically

Run:
kubectl get pods
kubectl get nodes
kubectl -n kube-system logs -f deployment/cluster-autoscaler


##Monitoring and Logging solution (Prometheus, Grafana and Loki)

###Deploy Loki

kubectl apply -f Kubernetes\monitoring\Loki

###Deploy Grafana

kubectl apply -f Kubernetes\monitoring\graphana

###Deploy prometheus

kubectl apply -f Kubernetes\monitoring\prometheus

##Clean Up 

Run:

kubectl delete -f Kubernetes\monitoring\Loki
kubectl delete -f Kubernetes\monitoring\graphana
kubectl delete -f Kubernetes\monitoring\prometheus
kubectl delete -f Kubernetes/HPA/sampleapp.yml
kubectl delete -f Kubernetes/HPA/hpa.yml
kubectl delete -f Kubernetes/HPA/sampleappservice.yml
kubectl delete -f Kubernetes/global/metrics.yml
kubectl delete -f Kubernetes/global/cluster-autoscaler.yml

cd Terraform/env

#terraform destroy --auto-approve
