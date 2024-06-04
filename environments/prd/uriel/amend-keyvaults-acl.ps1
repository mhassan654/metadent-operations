# Set the subscription
az account set --subscription "9f3afebc-aa2c-42fa-97a3-7c9435c6721c"
$env= "prd"
$resourceGroupName = "uriel-$env-rg"
$location = "WestEurope"
$keyVaultNameFe = "uriel-fe-$env-01"
$keyVaultNameBe = "uriel-be-$env-01"
$keyVaultNameEmails = "uriel-emails-$env-01"


# # Amend frontend key vault
az deployment group create --resource-group $resourceGroupName `
    --template-file "./keyvaults-acl.bicep" --mode Incremental `
    --parameters keyVaultName=$keyVaultNameFe

# # Amend backend key vault
az deployment group create --resource-group $resourceGroupName `
    --template-file "./keyvaults-acl.bicep" --mode Incremental `
    --parameters keyVaultName=$keyVaultNameBe
    
# # Amend emails key vault
az deployment group create --resource-group $resourceGroupName `
    --template-file "./keyvaults-acl.bicep" --mode Incremental `
    --parameters keyVaultName=$keyVaultNameEmails
