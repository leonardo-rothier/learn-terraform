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

### learn-terraform-dependencies
We understand here the implicit and explicit dependency between resources being created and being destroyed. The implicit is reconized by terraform by your configuration, as in the example on main.tf the `aws_eip.ip` resource need a information on the `aws_instance.example_c` resource, in this case we will have a implicit dependency solved by Terraform.  
The explicit dependency occurs when, for example, an application running in one instance relies on a storage service or another application hosted in a different instance (e.g., a backend depending on a database). In such cases, we need to use the `depends_on` arugment within the resource block that has this internal dependency.

### learn-terraform-functions
In this learn we show how to make terraform configuration more dynamic by using built-in functions. We used `lookup` function to access values from maps based on an input variable, passing `aws_region` variable to return a ami from a amis map.  
We used to the `templatefile` function to generate a script with interpolated values, and the `file` function to use the contents of a file as-is within the configuration and used to pass a local created SSH key to pair to aws and used this same one to configure our ec2 instance.  
On the script used by the templatefile we crete a systemd service to run a Go web app on the just created EC2 instance.

### learn-terraform-expressions
In this learn we see some expressions as conditional expression, how they are used and works on terrarform, basically the conditional expression works as the ternary operator on other languages ` condition ? value1 : value2 `. Other expression used on this configuration was the splat `*`, we used to create a output value, the splat expression iterate in a given list and return all the values based on the shared attibute defined, for example on `outputs.tf` the `aws_instance.ubuntu.*.private_dns` to output the private_dns from all instance resource create by our configuration.

### learn-terraform-modules-use
In this tutorial we start to use external modules for our Terraform configuration, manage module versions, configure module input variables, and use module output values. For this we use the aws vpc module tha we find on the `https://registry.terraform.io/` a published one, and the same for the ec2 instances used.

### learn-terraform-modules-create
The focus here was to create a local module, HashiCorp recommend that every Terraform configuration be created with the assumption to be reusable, this reusable configuration is called child module and are referenced by the root Terraform configuration. The reusable module created on this example was a configuration to create a aws bucket to host a static website. To configure the module we use variables to set inputs needed by this module and to exposed data about the resources we configure outputs.

### learn-terraform-workspace
Workspace helps us to complete separate enviroment and allow us to use the same Terraform code but with different state files, is very useful if you want your environment to stay as similar to each other as possible, it very useful when you are providing development infrastructure to a team that wants to simulate running in production.  
To use this locally you can use the `terraform workspace` commands. To create the dev workspace we run `terraform workspace new dev` now if i initialized my configuration and apply it will be create a new state for this specific workspace. To select and work with other workspace environment we use the `terraform workspace select <workspace-name>` command. We used the `terraform.workspace` variable inside our configuration to modify things on our configuration considering the workspace that i'm currently using.     
With the HCP is a little different but it works near the same. In this configuration we provisioned a instance and bucket based on its workspace, that with the same code we can deploy a dev a prod environment.

### learn-terraform-state
Here we are focusing on how to handle states on Terraform. After your first apply you can run `terraform state show` to print out all your applied Terraform configuration, that is extracted by the generated `terraform.tfstate` file generated during the apply command. To list all resources present on your configuration states use the `terraform state list` command and after list to see just one state in details we use the `terraform state show <resource-address>`.  
On this repo we created 2 terraform configurations(2 modules), one creating a `aws_instance.example` resource and the other creating `aws_instance.example_new`. To move the example_new resource to the first configuration state file we use the `terraform state mv` command with the flag `-state-out` to specify the destination, example:  
`terraform state mv -state-out="../terraform.tfstate" aws_instance.example_new aws_instance.example_new` # this inside the configuration dir with the example_new instance.  
To remove a resource from a state without destroying it, to indicate that your Terraform configuration will no longer manager the resource, we comment the resource block that we want to remove and implement the `removed` block to instruct Terraform to remove the resource from state, but not destroy it, as we did with the `aws_instance.example_new` in the end of the `main.tf` file.  
To undo the remove resource from state file, just comment the `removed` block, uncomment the resource block and on the cli run `terraform import` command to bring this instance back into your state file:  
`terraform import aws_instance.example_new <INSTANCE_ID>`  
And to just update your local state if the currently state of the real infrastructure just run `terraform refresh`.

### learn-terraform-targeting
In this tutorial we provision a S3 bucket with some objects in it, and after that we applied changes incrementally using the `-target` flag option. When we use the `-target` flag terraform wll update just the resource that i'm targeting and the resources that its depends on. Example:  
`terraform apply -target=aws_s3_object.objects[0] -target=aws_s3_object.objects[1]`  
  
![Demo Screenshot](learn-terraform-targeting/assets/terraform-target.png)

### learn-terraform-drift-management  
Example demonstrating Terraform drift detection and resolution after manual AWS changes.

#### Steps:  
1. **Induce Drift**:  
   - Create a new security group allowing port 8080:  
     ```bash
     export SG_ID=$(aws ec2 create-security-group --group-name "sg_web" --description "allow 8080" --output text --query 'GroupId')
     aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 8080 --cidr 0.0.0.0/0
     ```  
   - Attach the SG to the EC2 instance via AWS Console (EC2 > Network Interfaces).  
2. **Detect Drift**:  
   ```bash
   terraform plan -refresh-only  # Shows new SG added to EC2's security groups
   ```  
3. **Sync State**:  
   ```bash
   terraform apply -refresh-only  # Updates state to match real infrastructure
   ```  
4. **Reconcile Drift**:  
   - **Update Terraform Config**: Add the new SG and its rule to your `.tf` files.  
   - **Import Resources**:  
     ```bash
     terraform import aws_security_group.sg_web $SG_ID
     terraform import aws_security_group_rule.sg_web_ingress "${SG_ID}_ingress_tcp_8080_8080_0.0.0.0/0"
     ```  
   - **Apply Changes**:  
     ```bash
     terraform apply  # Ensures configuration matches infrastructure
     ```  
#### Key Notes:  
- Use `-refresh-only` to inspect/apply state changes without altering resources.  
- Update Terraform config **and** import manually created resources to prevent future drift.  
