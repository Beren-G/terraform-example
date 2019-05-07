# AWS Terraform Example 

This Terraform example creates an ASG with 1 ubuntu instance with a max of two. It then attaches it to an ELB. 

Cloudwatch alarms for unhealthy hosts in the load balancer and scaling alarms for the ASG are also configured. The action for these is to log to SNS. 

It also sends logs to S3 and stores the state on S3..

## Setup

Set up a user which has access to EC2, S3, DynamoDB and SNS

Create an S3 bucket to store the Terraform state and change this in main.tf. 

Then set up a DynamoDB table called "terraform-lock" with key "lock_id".

Set backend vars in backend.tfvars then run `tf-init-dev.sh`, or run the below command.
```
terraform init -backend-config=./backend.tfvars
```

## Notes


If the you get this error: "Error acquiring the state lock" - run this:

```
terraform apply -lock=false
```

Caution, when you destroy, you destroy the S3 Bucket as well! This can be disabled by removing `force_destroy`


### To Do
Take back-end code out of main.tf and make it DRYer.




