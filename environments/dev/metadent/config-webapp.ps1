param(
     [Parameter()][string]$ResourceGroupFilePath = "../../resourcegroup.bicep",
     [Parameter()][string]$ResourceFolder = "."     
 )


# Set the subscription
az account set --subscription "9f3afebc-aa2c-42fa-97a3-7c9435c6721c"
$env= "dev"
$clientName = "metadent";
$resourceGroupName = "$clientName-afr-$env-rg"
$dnsZoneBackend="$env.api.$clientName.cloud"
$appServicePlanName = "web-afr-$env-01"
$webAppNameBackend = "$clientName-afr-be-$env-01"
$appServicePlanResourceGroupName = "web-afr-$env-rg"
$vnetResourceGroupName = "network-afr-$env-rg"
$vnetName = "$clientName-afr-dev-01"
$appServicePlanName = "web-afr-$env-01"


# # Deploy the resources
az deployment group create --resource-group $resourceGroupName `
                            --template-file "$ResourceFolder/webapp-backend.bicep" --mode Incremental `
                            --parameters webAppNameBackend=$webAppNameBackend `
                                        dnsZoneBackend=$dnsZoneBackend `
                                        appServicePlanResourceGroupName=$appServicePlanResourceGroupName `
                                        appServicePlanName=$appServicePlanName `
                                        vnetResourceGroupName=$vnetResourceGroupName `
                                        vnetName=$vnetName

