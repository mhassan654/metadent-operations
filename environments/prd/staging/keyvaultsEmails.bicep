@description('Name of the Key Vault')
@minLength(3)
param keyVaultName string
param sqlServerName string
param sqlServerResourceGroup string
param sqlDatabaseName string

param sqlAppUser string 

@secure()
param sqlAppPwd string
param sqlDeployUser string

@secure()
param sqlDeployPwd string

@description('Location for all resources.')
param location string = resourceGroup().location

@description('The list of object IDs for users, groups, or applications to assign as Key Vault administrators.')
param objectIdList array = [
  '14685cef-d43c-48fa-ab24-2e0373c16653' // DEV_ADMINS
  '804da5c2-e83b-4cbe-9695-267014b6775d' // service connection app reg
  'a7d73e46-7259-4b0a-be5c-23c84f26c6a4' // service connection app reg Metadent Operations  
]

resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: [
      for objectId in objectIdList: {
        tenantId: subscription().tenantId
        objectId: objectId
        permissions: {
          secrets: ['get', 'list']
        }
      }
    ]
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
  }
}

resource secretsqlServerName 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'sqlServerName'
  properties: {
    value: sqlServerName
  }
}

resource secretsqlServerResourceGroup 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'sqlServerResourceGroup'
  properties: {
    value: sqlServerResourceGroup
  }
}

resource secretsqlDatabaseName 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'sqlDatabaseName'
  properties: {
    value: sqlDatabaseName
  }
}

resource secretsqlAppUser 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'sqlAppUser'
  properties: {
    value: sqlAppUser
  }
}
resource secretsqlAppPwd 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'sqlAppPwd'
  properties: {
    value: sqlAppPwd
  }
}
resource secretsqlDeployUser 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'sqlDeployUser'
  properties: {
    value: sqlDeployUser
  }
}
resource secretsqlDeployPwd 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'sqlDeployPwd'
  properties: {
    value: sqlDeployPwd
  }
}

output keyVaultUri string = keyVault.properties.vaultUri
