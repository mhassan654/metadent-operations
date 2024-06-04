param(
     [Parameter()][string]$ResourceGroupFilePath = "../../resourcegroup.bicep",
     [Parameter()][string]$ResourceFolder = "."     
 )

# Set the subscription
az account set --subscription "9f3afebc-aa2c-42fa-97a3-7c9435c6721c"
$env= "prd"
$resourceGroupNameSql = "sql-afr-$env-rg"
$sqlServerName = "md-sql-afr-$env-01"
$keyVaultName = $sqlServerName


# Create the resource groups
az deployment sub create --name subscriptionDeployment --location $location `
    --template-file $ResourceGroupFilePath `
    --parameters resourceGroupName=$resourceGroupNameSql resourceGroupLocation=$location


# Check if the secret exists
$secretExists=$(az keyvault secret show --name sqlAdminPwd --vault-name $keyVaultName --query id -o tsv 2>$null)

# If the secret does not exist, deploy the Bicep file
if ([string]::IsNullOrEmpty($secretExists)) {

    # # Deploy the resources
    [string] $password = [guid]::NewGuid().ToString();

    az deployment group create --resource-group $resourceGroupNameSql `
        --template-file "$ResourceFolder/keyvaults.bicep" --mode Incremental `
        --parameters resourceGroupName=$resourceGroupNameSql `
                    keyVaultName=$keyVaultName `
                    sqlAdminUser=$sqlAdminUser `
                    sqlAdminPwd=$password `
                    sqlServerName=$sqlServerName

}

az deployment group create --resource-group $resourceGroupNameSql `
    --template-file "$ResourceFolder/mysql.bicep" --mode Incremental `
    --parameters sqlServerName=$sqlServerName `
                sqlAdminUser=$sqlAdminUser `
                sqlAdminPwd=$password `
                skuName=$skuName `
                mysqlVersion=$mysqlVersion `
                vnetResourceGroupName=$vnetResourceGroupName `
                subnetName=$subnetName
