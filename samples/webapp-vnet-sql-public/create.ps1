$resourceGroupName = "oscar-resource-group"
$location = "WestEurope"
az group create --name $resourceGroupName --location $location
az deployment group create --resource-group $resourceGroupName --template-file ./vnet.bicep --mode Incremental
az deployment group create --resource-group $resourceGroupName --template-file ./mysql.bicep --mode Incremental
az deployment group create --resource-group $resourceGroupName --template-file ./webapps.bicep --mode Incremental