param(
     [Parameter()][string]$ResourceGroupFilePath = "../../../resourcegroup.bicep",
     [Parameter()][string]$ResourceFolder = "."     
 )


function GetRandomString(){
    $length = 12  # Length of the random string
    $characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'
    $randomString = -join ((1..$length) | ForEach-Object { Get-Random -Maximum $characters.length } | ForEach-Object { $characters[$_] });

    return $randomString;
}

# Set the subscription
az account set --subscription "9f3afebc-aa2c-42fa-97a3-7c9435c6721c"
$location = "westeurope"
$resourceGroupNameVm = "adoagent-lin-rg"
$keyVaultName = "adoagent-lin-01";
$vmSize="Standard_E2_v5"
$vmName=$keyVaultName

# # Create the resource groups
az deployment sub create --name subscriptionDeployment --location $location `
    --template-file $ResourceGroupFilePath `
    --parameters resourceGroupName=$resourceGroupNameVm resourceGroupLocation=$location


# Check if the secret exists
$adminUser=$(az keyvault secret show --name adminUser --vault-name $keyVaultName --query id -o tsv 2>$null)
$adminPwd=$(az keyvault secret show --name adminPwd --vault-name $keyVaultName --query id -o tsv 2>$null)

# If the secret does not exist, deploy the Bicep file
if ([string]::IsNullOrEmpty($adminUser) -or [string]::IsNullOrEmpty($adminPwd)) {

    # # Deploy the resources
    $adminUser = GetRandomString;
    $adminPwd = GetRandomString;

    az deployment group create --resource-group $resourceGroupNameVm `
        --template-file "$ResourceFolder/keyvaults.bicep" --mode Incremental `
        --parameters keyVaultName=$keyVaultName `
                    adminUser=$adminUser `
                    adminPwd=$adminPwd

}
else
{
    $adminUser=$(az keyvault secret show --name adminUser --vault-name $keyVaultName --query value -o tsv)
    $adminPwd=$(az keyvault secret show --name adminPwd --vault-name $keyVaultName --query value -o tsv)
}

# # Deploy the resources
az deployment group create --resource-group $resourceGroupNameVm `
    --template-file "$ResourceFolder/virtual-machine-lin.bicep" --mode Incremental `
    --parameters adminUser=$adminUser `
                adminPwd=$adminPwd `
                vmName=$vmName `
                vmSize=$vmSize

