$resourceGroupName = 'metadent-dev-rg-01'
$location = 'WestEurope'

az deployment group create --resource-group $resourceGroupName --template-file ./webapps.bicep --mode Complete
