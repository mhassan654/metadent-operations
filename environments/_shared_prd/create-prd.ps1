$ResourceGroupFilePath = "../resourcegroup.bicep"
$VirtualNetworkFolder = "virtual_networks"
$DataServicesFolder = "data_services"
. $PSScriptRoot/virtual_networks/create-vnet.ps1 -ResourceGroupFilePath $ResourceGroupFilePath -ResourceFolder $VirtualNetworkFolder
. $PSScriptRoot/data_services/create-server.ps1 -ResourceGroupFilePath $ResourceGroupFilePath -ResourceFolder $DataServicesFolder