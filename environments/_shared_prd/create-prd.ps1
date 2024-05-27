
$resourceGroupNameAdo = "ado-agents-rg"
$location = "WestEurope"

az deployment sub create --name subscriptionDeployment --location $location `
    --template-file ../resourcegroup.bicep `
    --parameters resourceGroupName=$resourceGroupNameAdo resourceGroupLocation=$location

$resourceGroupNameNetwork = "network-afr-prd-rg"
az deployment sub create --name subscriptionDeployment --location $location `
    --template-file ../resourcegroup.bicep `
    --parameters resourceGroupName=$resourceGroupNameNetwork resourceGroupLocation=$location

$resourceGroupNameSql = "sql-afr-prd-rg"
    az deployment sub create --name subscriptionDeployment --location $location `
        --template-file ../resourcegroup.bicep `
        --parameters resourceGroupName=$resourceGroupNameSql resourceGroupLocation=$location

# vnet
az deployment group create --resource-group $resourceGroupNameNetwork --template-file ./virtual_networks/vnets.bicep --mode Incremental

# ado agents
$adminUsername = "hello";
$adminPassword = "ThisIsThat@123";
az deployment group create --resource-group $resourceGroupNameAdo --template-file ./virtual_machines/ado-agents/keyvaults.bicep --mode Incremental
az deployment group create --resource-group $resourceGroupNameAdo `
    --template-file ./virtual_machines/ado-agents/adoagent-win.bicep `
    --parameters adminUsername=$adminUsername adminPassword=$adminPassword `
    --mode Incremental

