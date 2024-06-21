param(
     [Parameter()][string]$ResourceGroupFilePath = "../../resourcegroup.bicep",
     [Parameter()][string]$ResourceFolder = "."     
 )


# Set the subscription
az account set --subscription "9f3afebc-aa2c-42fa-97a3-7c9435c6721c"
$env= "dev"
$clientName = "metadent";
$resourceGroupName = "$clientName-afr-$env-rg"
$location = "WestEurope"
$dnsZoneFrontend="$env.$clientName.cloud"
$dnsZoneBackend="$env.api.$clientName.cloud"
$appServicePlanName = "web-afr-$env-01"
$mysqlServerResourceGroupName = "sql-afr-$env-rg"
$mysqlServerName = "md-sql-afr-$env-01"
$webAppNameFrontend = "$clientName-afr-fe-$env-01"
$webAppNameBackend = "$clientName-afr-be-$env-01"
$appServicePlanResourceGroupName = "web-afr-$env-rg"
$vnetResourceGroupName = "network-afr-$env-rg"
$vnetName = "$clientName-afr-dev-01"
$appServicePlanName = "web-afr-$env-01"
$keyVaultNameFe = "$clientName-afr-fe-$env-01"
$keyVaultNameBe = "$clientName-afr-be-$env-01"
$keyVaultNameEmails = "md-emails-$env-01"
$sqlDatabaseName = "$($clientName)afr$($env)01"
$sqlDatabaseNameEmails = "$($clientName)afremails$($env)01"

# # Create the resource groups
az deployment sub create --name subscriptionDeployment --location $location `
    --template-file "$ResourceGroupFilePath" `
    --parameters resourceGroupName=$resourceGroupName resourceGroupLocation=$location

# # Deploy the resources

# Check if the secret exists

$secretExists=$(az keyvault secret show --name sqlAppPwd --vault-name $keyVaultNameBe --query id -o tsv 2>$null)

# If the secret does not exist, deploy the Bicep file
$sqlServerName = "$mysqlServerName.mysql.database.azure.com"
$sqlServerResourceGroup = $mysqlServerResourceGroupName

if ([string]::IsNullOrEmpty($secretExists)) {

    # # Deploy key vaults
    $sqlAppUser = $sqlDatabaseName
    $sqlDeployUser = "deploy$($sqlDatabaseName)"
    [string] $sqlAppPwd = [guid]::NewGuid().ToString();
    [string] $sqlDeployPwd = [guid]::NewGuid().ToString();

    az deployment group create --resource-group $resourceGroupName `
        --template-file "$ResourceFolder/keyvaults.bicep" --mode Incremental `
        --parameters keyVaultNameBe=$keyVaultNameBe `
                    keyVaultNameFe=$keyVaultNameFe `
                    sqlServerName=$sqlServerName `
                    sqlServerResourceGroup=$sqlServerResourceGroup `
                    sqlDatabaseName=$sqlDatabaseName `
                    sqlAppUser=$sqlAppUser `
                    sqlAppPwd=$sqlAppPwd `
                    sqlDeployUser=$sqlDeployUser `
                    sqlDeployPwd=$sqlDeployPwd
}

$keyVaultNameInfrastructure = "metadent-infra-01"
$smtpUsernameSecret = "smtp-username-prd"
$smtpPasswordSecret = "smtp-password-prd"

# Check if the smtp secrets exist
$secretExists=$(az keyvault secret show --name $smtpUsernameSecret --vault-name $keyVaultNameBe --query id -o tsv 2>$null)

if ([string]::IsNullOrEmpty($secretExists)) {

    $smtpUsername=$(az keyvault secret show --name $smtpUsernameSecret --vault-name $keyVaultNameInfrastructure --query value -o tsv 2>$null)
    $smtpPassword=$(az keyvault secret show --name $smtpPasswordSecret --vault-name $keyVaultNameInfrastructure --query value -o tsv 2>$null)

    # # Deploy key vaults
    az deployment group create --resource-group $resourceGroupName `
        --template-file "$ResourceFolder/keyvaultsSmtp.bicep" --mode Incremental `
        --parameters keyVaultName=$keyVaultNameBe `
                    smtpUsername=$smtpUsername `
                    smtpPassword=$smtpPassword

}

$secretExistsEmails=$(az keyvault secret show --name sqlAppPwd --vault-name $keyVaultNameEmails --query id -o tsv 2>$null)

# If the secret does not exist, deploy the Bicep file

if ([string]::IsNullOrEmpty($secretExistsEmails)) {

    # # Deploy key vaults
    $sqlAppUser =$sqlDatabaseNameEmails
    $sqlDeployUser = "deploy$($sqlDatabaseNameEmails)"
    [string] $sqlAppPwd = [guid]::NewGuid().ToString();
    [string] $sqlDeployPwd = [guid]::NewGuid().ToString();

    az deployment group create --resource-group $resourceGroupName `
        --template-file "$ResourceFolder/keyvaultsEmails.bicep" --mode Incremental `
        --parameters keyVaultName=$keyVaultNameEmails `
                    sqlServerName=$sqlServerName `
                    sqlServerResourceGroup=$sqlServerResourceGroup `
                    sqlDatabaseName=$sqlDatabaseNameEmails `
                    sqlAppUser=$sqlAppUser `
                    sqlAppPwd=$sqlAppPwd `
                    sqlDeployUser=$sqlDeployUser `
                    sqlDeployPwd=$sqlDeployPwd
}

az deployment group create --resource-group $resourceGroupName `
                            --template-file "$ResourceFolder/webapps.bicep" --mode Incremental `
                            --parameters webAppNameFrontend=$webAppNameFrontend `
                                        webAppNameBackend=$webAppNameBackend `
                                        dnsZoneFrontend=$dnsZoneFrontend `
                                        dnsZoneBackend=$dnsZoneBackend `
                                        appServicePlanResourceGroupName=$appServicePlanResourceGroupName `
                                        appServicePlanName=$appServicePlanName `
                                        vnetResourceGroupName=$vnetResourceGroupName `
                                        vnetName=$vnetName

$storageAccountName = $sqlDatabaseName
az deployment group create --resource-group $resourceGroupName `
                            --template-file "$ResourceFolder/storageaccounts.bicep" --mode Incremental `
                            --parameters storageAccountName=$storageAccountName `
                                        keyvaultName=$keyVaultNameBe

# Deploy the main application database
az deployment group create --resource-group $resourceGroupName `
                            --template-file "$ResourceFolder/database.bicep" --mode Incremental `
                            --parameters mysqlServerResourceGroupName=$mysqlServerResourceGroupName `
                            --parameters mysqlServerName=$mysqlServerName `
                            --parameters databaseName=$sqlDatabaseName

# Deploy the emails database
az deployment group create --resource-group $resourceGroupName `
                            --template-file "$ResourceFolder/database.bicep" --mode Incremental `
                            --parameters mysqlServerResourceGroupName=$mysqlServerResourceGroupName `
                            --parameters mysqlServerName=$mysqlServerName `
                            --parameters databaseName=$sqlDatabaseNameEmails