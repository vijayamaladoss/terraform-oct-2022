# Day3

## Lab - Creating multiple Virtual Machines in Azure using Terraform
```
cd ~/terraform-oct-2022
git pull
cd Day3/azure-multiple-vms
terraform init
terraform apply --auto-approve
terraform output public_vm_ip_addresses
```

Once you are done with the above lab exercise, make sure to cleanup the resources created
```
terraform destroy --auto-approve
```
