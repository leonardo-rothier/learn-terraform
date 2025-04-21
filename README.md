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
Used to test the **terraform init** command: downloading providers plugins, downloading/initilizing modules, configuring your workspace. In this module was used an aws provider to create a EC2 resource with a instance name generated randomly using the random provider.  

### learn-terraform-plan
We are testing the plan command, that is used to create a plan consisting of a set of changes that will make the targeted resource match your configuration.
You can also save a plan with `-out` flag to apply later:
`terraform plan -out "tfplan"`
And after as a json file:
`terraform show -json "tfplan" | jq > tfplan.json`  
You can also create a destroy plan file by:  
`terraform plan -destroy -out "tfplan-destroy"

### learn-terraform-apply
This one to test the apply of our configurations, we can use together with the previous generated plan and apply it or just run the `terraform apply` command that do boths in a single command.  
We can too run the apply with the `-replace` flag, to force a replace to a specific resource that for some reason is not working well, that maybe beside your terraform configuration.  
`terraform state list` to list the resources in our configuration  
`terraform apply -replace "<resource-address>"`  
We can also use the `-target` flag, he is a little more specific, you use when you want to modify just a specific part of your infraestructure, to apply a specific resource configuration only, rather than apply the entire configuration.

### learn-terraform-versions
This directory use a hashicorp scripted code to initialize a php code served by httpd (apache) inside a provisioned EC2 instance.  
We use some version contraints one for the version of the terraform used to manage the configuration and the other to the providers used by our terraform configuration.  

As best practice we consider using the `~>` style version constraints to pin our major and minor versions. As on aws the aws provider `~> 5.95.0` it means that i want to get the latest version inside the 5.95, for example 5.95.1 when it's released.  

To upgrade the version of your resource based on your defined constraints you will need to run:  
`terraform init -upgrade`

### learn-terraform-variables
Here we explore more about variables, parameterize this configuration with Terraform input variables. Interpolate variables to strings, and variable validation.  
To parameterize our configuration we used the `variable` block specifying type, description and some time a default value.   
If you don't specify a default value, you will need to pass its values some how, passing as parameter as we did with our local aws-instance module, `-var` flag during the `terraform apply` command (ex: terraform apply -var aws_region=us-east-1) or using a .tfvars file. The default name is `terraform.tfvars` otherwise you will need to use the `-var-file` flag to specify other file by its name.  
To interpolate variables in strings, we use the `"${}"` and inside it we put the var that we want to interpolate, as on `name = "lb-${random_string.lb_id.result}-${var.project_name}"`  
To create rules for a variable we use the `validation` block nested within the variable block.


### learn-terraform-sensitive-variables
Within this directory we are seeing how to protect sensitive data. The first step is to set inside the `variable` block set the variable as sensitive `sensitive = true`.  
After this you need to decide how you are going to set these variables values:  
- Environment variable ` export TF_VAR_var_name=value ` inside your local machine that is running the terraform commands.   
- Through your HCP workspace's Variables page, you can add there and mark as sensitive.  
- tfvars files, can create a `secret.tfvars` file. (Remember that it cannot be commited in your version control, use .gitignore)  

Notice even flagged as sensitve, terraforms need to store these values in your state, so marking variable as sensitive is not sufficient to secure them.

### learn-terraform-sensitive-outputs
Here we are testing the `terraform output` funcionality, this one are basically used to export structured data about your resources configured on your configuration files.
Are mainly used to automation tools or as a data source for another Terraform workspace.  
To configure outputs, it's a good pratice to create a separated file called `outputs.tf`. As they are saved on the state of our terraform to get applied and ready to use 
need to be applied before try to export the variable using the `terraform apply` command.  
After this you can use the `terraform output` to list all outputs values from your configuration, and `terraform output <output_name>` to query one individual output. Use a `sensitive` flag inside the output block, so that terraform can redact the values of sensitive outputs to avoid accidently printing them on console.  
Terraform output are also the only way to share data from child module to root module.

### learn-terraform-data-sources
Here we explore the terraform data sources, on the new learn directory we use the data sources to make our configuration more dynamic.  
First we separated the vpc configuration and aws EC2 instance configuration in two workspaces, and use the `terraform_remote_state` data source to query information about our just created VPC to fit in ours EC2 instances and its load balancer.