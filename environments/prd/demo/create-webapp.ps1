param(
     [Parameter()][string]$ResourceGroupFilePath = "../../resourcegroup.bicep",
     [Parameter()][string]$ResourceFolder = "."     
 )


# Set the subscription
az account set --subscription "9f3afebc-aa2c-42fa-97a3-7c9435c6721c"
$env= "prd"
$clientName = "demo";
$resourceGroupName = "$clientName-$env-rg"
$dnsZoneFrontend="$clientName.metadent.cloud"
$dnsZoneBackend="$clientName.api.metadent.cloud"
$appServicePlanName = "web-afr-$env-01"
$webAppNameFrontend = "$clientName-fe-$env-01"
$webAppNameBackend = "$clientName-be-$env-01"
$appServicePlanResourceGroupName = "web-afr-$env-rg"
$vnetResourceGroupName = "network-afr-$env-rg"
$vnetName = "metadent-afr-$env-01"
$appServicePlanName = "web-afr-$env-01"

az deployment group create --resource-group $resourceGroupName `
                            --template-file "$ResourceFolder/webapps.bicep" --mode Incremental `
                            --parameters webAppNameFrontend=$webAppNameFrontend `
                                        webAppNameBackend=$webAppNameBackend `
                                        dnsZoneFrontend=$dnsZoneFrontend `
                                        dnsZoneBackend=$dnsZoneBackend `
                                        appServicePlanResourceGroupName=$appServicePlanResourceGroupName `
                                        appServicePlanName=$appServicePlanName `
                                        vnetResourceGroupName=$vnetResourceGroupName `
                                        vnetName=$vnetName


# To stop the web app
az webapp stop --name $webAppNameBackend --resource-group $resourceGroupName

# To start the web app
az webapp start --name $webAppNameBackend --resource-group $resourceGroupName


