# Set the subscription
az account set --subscription "9f3afebc-aa2c-42fa-97a3-7c9435c6721c"
$env= "prd"
$clientName = "staginglegacy";

$resourceGroupName =  "$clientName-$env-rg"
$keyVaultNameFe = "$clientName-fe-$env-02"
$keyVaultNameBe = "$clientName-be-$env-02"
$keyVaultNameEmails = "$clientName-emails-$env-02"


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
