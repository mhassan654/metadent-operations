[string]$ResourceFolder = "../../../modules/clients"

# Set the subscription
az account set --subscription "9f3afebc-aa2c-42fa-97a3-7c9435c6721c"
$env= "prd"
$clientName = "stg-i";
$resourceGroupName = "staging-$env-rg"
$keyVaultNameBe = "$clientName-be-$env-01"

# # Amend backend key vault
az deployment group create --resource-group $resourceGroupName `
    --template-file "$ResourceFolder/keyvaults-rg.bicep" --mode Incremental `
    --parameters keyVaultNameBe=$keyVaultNameBe

