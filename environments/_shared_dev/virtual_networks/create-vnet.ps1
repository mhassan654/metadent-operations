param(
     [Parameter()][string]$ResourceGroupFilePath = "../../resourcegroup.bicep",
     [Parameter()][string]$ResourceFolder = "."     
 )

# Set the subscription
az account set --subscription "9f3afebc-aa2c-42fa-97a3-7c9435c6721c"
$location = "westeurope"
$resourceGroupNameVnet = "network-afr-prd-rg"
$virtualNetworkName = 'metadent-afr-dev-01'
$destinationResourceGroupName = "agents"
$destinationNetworkname = "agent-win-01-vnet"

# # Create the resource groups
az deployment sub create --name subscriptionDeployment --location $location `
    --template-file $ResourceGroupFilePath `
    --parameters resourceGroupName=$resourceGroupNameVnet resourceGroupLocation=$location

# # Deploy the vnet
az deployment group create --resource-group $resourceGroupNameVnet `
    --template-file "$ResourceFolder/vnets.bicep" --mode Incremental `
    --parameters resourceGroupName=$resourceGroupNameVnet `
                keyVaultNameBe=$virtualNetworkName

# # Deploy the peerings
az deployment group create --resource-group $resourceGroupNameVnet `
    --template-file "$ResourceFolder/vnet-peers.bicep" --mode Incremental `
    --parameters sourceNetworkname=$virtualNetworkName  `
                destinationResourceGroupName=$destinationResourceGroupName `
                destinationNetworkname=$destinationNetworkname                

