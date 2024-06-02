param(
     [Parameter()][string]$ResourceGroupFilePath = "../../resourcegroup.bicep",
     [Parameter()][string]$ResourceFolder = "."     
 )

# Set the subscription
az account set --subscription "9f3afebc-aa2c-42fa-97a3-7c9435c6721c"
$location = "westeurope"
$resourceGroupNameVnet = "network-afr-prd-rg"

# # Create the resource groups
az deployment sub create --name subscriptionDeployment --location $location `
    --template-file $ResourceGroupFilePath `
    --parameters resourceGroupName=$resourceGroupNameVnet resourceGroupLocation=$location

# # Deploy the resources
az deployment group create --resource-group $resourceGroupNameVnet `
    --template-file "$ResourceFolder/vnets.bicep" --mode Incremental

