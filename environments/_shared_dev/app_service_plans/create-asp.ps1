param(
     [Parameter()][string]$ResourceGroupFilePath = "../../resourcegroup.bicep",
     [Parameter()][string]$ResourceFolder = "."     
 )

# Set the subscription
az account set --subscription "9f3afebc-aa2c-42fa-97a3-7c9435c6721c"
$sku = 'B2'
$env = "dev"
$appServicePlanName = "web-afr-$env-01"
$resourceGroupNameAsp = "web-afr-$env-rg"
$location = "WestEurope"

# Create the resource groups
az deployment sub create --name subscriptionDeployment --location $location `
    --template-file $ResourceGroupFilePath `
    --parameters resourceGroupName=$resourceGroupNameAsp resourceGroupLocation=$location


az deployment group create --resource-group $resourceGroupNameAsp `
                            --template-file "$ResourceFolder/asp.bicep" --mode Incremental `
                            --parameters sku=$sku `
                                        appServicePlanName=$appServicePlanName

