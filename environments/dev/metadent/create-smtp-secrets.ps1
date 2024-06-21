param(
     [Parameter()][string]$ResourceGroupFilePath = "../../resourcegroup.bicep",
     [Parameter()][string]$ResourceFolder = "."     
 )


# Set the subscription
az account set --subscription "9f3afebc-aa2c-42fa-97a3-7c9435c6721c"
$env= "dev"
$clientName = "metadent";
$resourceGroupName = "$clientName-afr-$env-rg"
$keyVaultNameBe = "$clientName-afr-be-$env-01"
$keyVaultNameInfrastructure = "metadent-infra-01"
$smtpUsernameSecret = "smtp-username-dev"
$smtpPasswordSecret = "smtp-password-dev"

# # Deploy the resources

# Check if the smtp secrets exist
$secretExists=$(az keyvault secret show --name $smtpUsernameSecret --vault-name $keyVaultNameBe --query id -o tsv 2>$null)

if ([string]::IsNullOrEmpty($secretExists)) {

    $smtpUsername=$(az keyvault secret show --name $smtpUsernameSecret --vault-name $keyVaultNameInfrastructure --query id -o tsv 2>$null)
    $smtpPassword=$(az keyvault secret show --name $smtpPasswordSecret --vault-name $keyVaultNameInfrastructure --query id -o tsv 2>$null)

    # # Deploy key vaults
    az deployment group create --resource-group $resourceGroupName `
        --template-file "$ResourceFolder/keyvaultsSmtp.bicep" --mode Incremental `
        --parameters keyVaultName=$keyVaultNameBe `
                    smtpUsername=$smtpUsername `
                    smtpPassword=$smtpPassword

}

