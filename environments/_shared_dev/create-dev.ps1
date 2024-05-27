$location = "WestEurope"

$resourceGroupNameNetwork = "network-afr-dev-rg"
az deployment sub create --name subscriptionDeployment --location $location `
    --template-file ../resourcegroup.bicep `
    --parameters resourceGroupName=$resourceGroupNameNetwork resourceGroupLocation=$location

$resourceGroupNameSql = "sql-afr-dev-rg"
az deployment sub create --name subscriptionDeployment --location $location `
    --template-file ../resourcegroup.bicep `
    --parameters resourceGroupName=$resourceGroupNameSql resourceGroupLocation=$location

$resourceGroupNameWeb = "web-afr-dev-rg"
az deployment sub create --name subscriptionDeployment --location $location `
    --template-file ../resourcegroup.bicep `
    --parameters resourceGroupName=$resourceGroupNameWeb resourceGroupLocation=$location    

# vnet
az deployment group create --resource-group $resourceGroupNameNetwork --template-file ./virtual_networks/vnets.bicep --mode Incremental
az deployment group create --resource-group $resourceGroupNameSql --template-file ./data_services/mysql.bicep --mode Incremental
az deployment group create --resource-group $resourceGroupNameWeb --template-file ./app_service_plans/asp.bicep --mode Incremental

