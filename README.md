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

aws configure

This command links Terraform to your AWS account using the provided credentials.

###Clone the repository.

Run

#git clone https://github.com/Martin-Raju/eks-terraform.git

(update all  values in the terraform.tfvars file)

#####Initialize Terraform

Navigate into the project directory.

Run:

#terraform init

This initializes the Terraform environment and downloads the required modules, providers, and backend configuration.

######Review the Terraform Configuration

You can preview the changes that Terraform will make by running:

#terraform plan

This helps ensure everything is set up correctly before making actual changes.

#####Apply the Terraform Configuration

To create the EKS cluster along with its VPC, run:

#terraform apply --auto-approve

Confirm the prompt to proceed. Terraform will begin provisioning the resources as defined in the configuration.

####verify cluster access
Run:
#aws eks --region <region> update-kubeconfig --name <cluster_name>

#kubectl get pods -A


###########Step-by-Step Guide: EKS Scaling Demonstration################

#####Install Metrics Server (for HPA)
Run:
#kubectl apply -f Kubernetes/metrics.yml

####Verify installation:
Run:
#kubectl get deployment metrics-server -n kube-system

#####Deploy a Sample Application
Run:
#kubectl apply -f Kubernetes/sampleapp.yml

#####Deploy a Sample service
Run:
#kubectl apply -f Kubernetes/sampleappservice.yml

######Verify the pod count 
Run:
#kubectl get pods 

####Deploy Horizontal Pod Autoscaler (HPA)
Run:
#kubectl apply -f Kubernetes/hpa.yml

######start a container and send an infinite loop of queries to the ‘php-apache’ service, listening on port 8080
Run:
# kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://hpa-demo-deployment; done"

####Monitor HPA:
Once CPU usage exceeds 50%, HPA will scale the pod count up.
Run:
#kubectl get hpa
#kubectl get pods
#kubectl get deployment hpa-demo-deployment 
#kubectl describe hpa

####Clean Up 
Run:
#kubectl delete -f Kubernetes/sampleapp.yml
#kubectl apply -f Kubernetes/hpa.yml
#kubectl delete -f Kubernetes/sampleappservice.yml
#kubectl delete -f Kubernetes/metrics.yml
#terraform destroy --auto-approve
