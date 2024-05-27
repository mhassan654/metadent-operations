# Set the subscription
az account set --subscription "9f3afebc-aa2c-42fa-97a3-7c9435c6721c"
$resourceGroupName = "metadent-afr-dev-rg"
$location = "WestEurope"

# # Create the resource groups
az deployment sub create --name subscriptionDeployment --location $location `
    --template-file ../../resourcegroup.bicep `
    --parameters resourceGroupName=$resourceGroupName resourceGroupLocation=$location


# # Deploy the resources

az deployment group create --resource-group $resourceGroupName --template-file ./webapps.bicep --mode Incremental
az deployment group create --resource-group $resourceGroupName --template-file ./keyvaults.bicep --mode Incremental
az deployment group create --resource-group $resourceGroupName --template-file ./storageaccounts.bicep --mode Incremental
az deployment group create --resource-group $resourceGroupName --template-file ./database.bicep --mode Incremental