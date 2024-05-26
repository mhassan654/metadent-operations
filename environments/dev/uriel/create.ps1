az account set --subscription "9f3afebc-aa2c-42fa-97a3-7c9435c6721c"

$resourceGroupName = 'uriel-dev-rg-01'

# resource group name for networks
$resourceNetworkGroupName="network-dev-rg-01"

# resource group for sql resources
$resourceSqlGroupName ="sql-dev-rg-01"

#  set location
$location ='WestEurope'

az group create --name $resourceGroupName --location $location
az group create --name $resourceNetworkGroupName --location $location
az group create --name $resourceSqlGroupName --location $location

az deployment group create --resource-group $resourceGroupName --template-file ./webapp.bicep --mode Complete
az deployment group create --resource-group $resourceGroupName --template-file ./keyvaults.bicep --mode Complete
az deployment group create --resource-group $resourceSqlGroupName --template-file ./mysql.bicep --mode Complete
az deployment group create --resource-group $resourceGroupName --template-file ./storageaccount.bicep --mode Complete
az deployment group create --resource-group $resourceNetworkGroupName --template-file ../../../_shared_dev/virtual_networks/vnet.bicep --mode Complete
