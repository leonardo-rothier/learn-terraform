## Pre-requisite
### To use HCP as i'm using it in my examples, you will need:
1- Create your HCP account  
2- use the ``` terraform login``` to log into your account (generate a token from you HCP user)  
3- After your fist ``` terraform init ``` command, go to HCP UI and configure your new created Workspace with AWS variables  
``` AWS_ACCESS_KEY_ID ``` and ``` AWS_SECRET_ACCESS_KEY```  
To generate them go on you AWS IAM -> Your User -> Security Credentials -> Create Access Key  

### If you are just runing locally without a remote backend setup:
1- Install AWS CLI ``` sudo yum install awscli -y```  
2- Generate the Access key on aws (AWS IAM -> Your User -> Security Credentials -> Create Access Key)  
3- Run ``` aws configure ``` command and enter with the access key  

_**Note**: in this case remember to remove the `cloud` block inside `terraform.tf` configuration._  
## Examples
### learn-terraform-init
Used to test the terraform init command, downloading providers plugins, initilizing modules, configuring you workspace.  
Was used an aws provider to create a EC2 resource with a instance name generated randomly using the random provider.  