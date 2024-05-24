# Set the subscription
az account set --subscription "9f3afebc-aa2c-42fa-97a3-7c9435c6721c"
$resourceGroupName = "metadent-dev-rg"
$resourceNetworkGroupName = "network-dev-rg"
$resourceSQLGroupName = "sql-dev-rg"
$location = "WestEurope"

# # Create the resource groups
az group create --name $resourceGroupName --location $location
az group create --name $resourceNetworkGroupName --location $location
az group create --name $resourceSQLGroupName --location $location

# # Deploy the resources
az deployment group create --resource-group $resourceNetworkGroupName --template-file ../_shared_dev/virtual_networks/vnet.bicep --mode Complete
az deployment group create --resource-group $resourceSQLGroupName --template-file ../_shared_dev/data_services/mysql.bicep --mode Complete
az deployment group create --resource-group $resourceGroupName --template-file ../_shared_dev/app_service_plans/asp.bicep --mode Complete
az deployment group create --resource-group $resourceGroupName --template-file ./webapps.bicep --mode Complete
az deployment group create --resource-group $resourceGroupName --template-file ./keyvaults.bicep --mode Complete