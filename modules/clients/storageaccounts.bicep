@description('metadent afr dev 01 storage account')
param location string = resourceGroup().location
param storageAccountName string
param keyvaultName string 

var containerName1 = 'backups'
var containerName2 = 'declarations'
var containerName3 = 'emailattachments'
var containerName4 = 'employees'
var containerName5 = 'favicons'
var containerName6 = 'imaging'
var containerName7 = 'logos'
var containerName8 = 'patients'
var containerName9 = 'temporaryreadpdffiles'

// storage account resource
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-04-01'={
  name:storageAccountName
  location:location
  sku:{
    name:'Standard_LRS'
  }
  kind: 'StorageV2'
  properties:{
    accessTier:'Hot'
  }
}

resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  parent: storageAccount
  name: 'default'
}

resource container1 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: blobServices
  name: containerName1
}
resource container2 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: blobServices
  name: containerName2
}
resource container3 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: blobServices
  name: containerName3
}
resource container4 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: blobServices
  name: containerName4
}
resource container5 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: blobServices
  name: containerName5
}
resource container6 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: blobServices
  name: containerName6
}
resource container7 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: blobServices
  name: containerName7
}
resource container8 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: blobServices
  name: containerName8
}
resource container9 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: blobServices
  name: containerName9
}

resource secretstorageAccountName 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${keyvaultName}/storageAccountName' 
  properties: {
    value: storageAccount.name
  }
}

resource secretstorageAccountKey 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${keyvaultName}/storageAccountKey'
  properties: {
    value: storageAccount.listKeys().keys[0].value
  }
}

resource secretstorageAccountConnectionString 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${keyvaultName}/storageAccountConnectionString'
  properties: {
    value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value};EndpointSuffix=core.windows.net'
  }
}
