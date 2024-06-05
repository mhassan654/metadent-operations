# Set the subscription
az account set --subscription "9f3afebc-aa2c-42fa-97a3-7c9435c6721c"
$env= "dev"
$clientName = "metadent";
$resourceGroupName = "$clientName-afr-$env-rg"
$storageAccountName = "$($clientName)afr$($env)01"

# # Amend frontend key vault
az deployment group create --resource-group $resourceGroupName `
    --template-file "./storageAccount-role.bicep" --mode Incremental `
    --parameters storageAccountName=$storageAccountName

