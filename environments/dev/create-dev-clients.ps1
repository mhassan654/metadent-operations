# Set the subscription
az account set --subscription "9f3afebc-aa2c-42fa-97a3-7c9435c6721c"
$resourceGroupName = "metadent-afr-dev-rg"
$location = "WestEurope"

# # Create the resource groups
az deployment sub create --name subscriptionDeployment --location $location `
    --template-file ../resourcegroup.bicep `
    --parameters resourceGroupName=$resourceGroupName resourceGroupLocation=$location


# # Deploy the resources
$BicepFiles = Get-ChildItem -Path ./metadent/ -Filter *.bicep

foreach ($File in $BicepFiles) {

    az deployment group create create --resource-group $resourceGroupName  `
        --template-file $File.FullName  --mode Incremental
    Write-Host "Deployed $($File.FullName)"
}
az deployment group create --resource-group $resourceGroupName --template-file ./metadent/webapps.bicep --mode Incremental
az deployment group create --resource-group $resourceGroupName --template-file ./metadent/keyvaults.bicep --mode Incremental
az deployment group create --resource-group $resourceGroupName --template-file ./metadent/storageaccounts.bicep --mode Incremental
az deployment group create --resource-group $resourceGroupName --template-file ./metadent/database.bicep --mode Incremental