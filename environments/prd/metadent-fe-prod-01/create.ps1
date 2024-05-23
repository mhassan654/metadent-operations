$resourceGroupName = 'metadent-prod-rg-01'
$location = 'WestEurope'

az deployment group create --resource-group $resourceGroupName --template-file ./webapp.bicep --mode Complete
