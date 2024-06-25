# Set the subscription
az account set --subscription "9f3afebc-aa2c-42fa-97a3-7c9435c6721c"
$clientScript = "create-client.ps1"

$ResourceGroupFilePath = "../../resourcegroup.bicep"
$ClientFolderMetadent = "../../modules/clients"
. "$PSScriptRoot/$ClientFolderMetadent/$clientScript" -ResourceGroupFilePath $ResourceGroupFilePath -ResourceFolder $ClientFolderMetadent
