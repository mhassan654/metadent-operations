$resourceGroupName = "HelloWorld"
$location = "WestEurope"
az group create --name $resourceGroupName --location $location
az deployment group create --resource-group $resourceGroupName --template-file .\vnet.bicep --mode Complete
az deployment group create --resource-group $resourceGroupName --template-file .\mysql.bicep --mode Complete
az deployment group create --resource-group $resourceGroupName --template-file .\webapps.bicep --mode Complete