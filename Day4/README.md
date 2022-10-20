# Day4

## Deploying your Python Azure Function as an App Service
```
cd ~/terraform-oct-2022
git pull
cd Day4/AppService

cd function-python
terraform init
terraform apply --auto-approve
```

When it prompts for location, you can type eastus or any other valid Azure Region.  Also you can type your name as prefix.  The prefix will be used to name the application and for computing the url.

