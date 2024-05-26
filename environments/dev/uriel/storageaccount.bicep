@description('uriel-be-prd-01 rsource location')
param location string = resourceGroup().location

var storageAccountName = 'urielprd01'

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
