$location = "NorthEurope"

$resourceGroupNameWeb = "web-afr-ne-prd-rg"
$appServicePlanName = "web-afr-ne-prd-01"
az deployment sub create --name subscriptionDeployment --location $location `
    --template-file ../resourcegroup.bicep `
    --parameters resourceGroupName=$resourceGroupNameWeb `
    resourceGroupLocation=$location    

az deployment group create --resource-group $resourceGroupNameWeb `
    --template-file ./app_service_plans/asp.bicep `
    --parameters appServicePlanName=$appServicePlanName `
    --mode Incremental

