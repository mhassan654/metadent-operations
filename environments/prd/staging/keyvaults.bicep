@description('Name of the Key Vault')
@minLength(3)
param keyVaultNameFe string
param keyVaultNameBe string
param sqlServerName string
param sqlServerResourceGroup string
param sqlDatabaseName string

param sqlAppUser string 

@secure()
param sqlAppPwd string
param sqlDeployUser string

@secure()
param sqlDeployPwd string
param secretNamewebAppName string = 'webAppName'
param webAppNameFe string = keyVaultNameFe  // keyvault name should be the sanee as the web app name
param webAppNameBe string = keyVaultNameBe


@description('Location for all resources.')
param location string = resourceGroup().location

@description('The list of object IDs for users, groups, or applications to assign as Key Vault administrators.')
param objectIdList array = [
  '14685cef-d43c-48fa-ab24-2e0373c16653' // DEV_ADMINS
  '804da5c2-e83b-4cbe-9695-267014b6775d' // service connection app reg Metadent
  'a7d73e46-7259-4b0a-be5c-23c84f26c6a4' // service connection app reg Metadent Operations
]

resource keyVaultFe 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: keyVaultNameFe
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

resource secretWebAppNameFe 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVaultFe
  name: secretNamewebAppName
  properties: {
    value: webAppNameFe
  }
}

resource keyVaultBe 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: keyVaultNameBe
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
  parent: keyVaultBe
  name: 'sqlServerName'
  properties: {
    value: sqlServerName
  }
}

resource secretsqlServerResourceGroup 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVaultBe
  name: 'sqlServerResourceGroup'
  properties: {
    value: sqlServerResourceGroup
  }
}

resource secretsqlDatabaseName 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVaultBe
  name: 'sqlDatabaseName'
  properties: {
    value: sqlDatabaseName
  }
}

resource secretsqlAppUser 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVaultBe
  name: 'sqlAppUser'
  properties: {
    value: sqlAppUser
  }
}
resource secretsqlAppPwd 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVaultBe
  name: 'sqlAppPwd'
  properties: {
    value: sqlAppPwd
  }
}
resource secretsqlDeployUser 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVaultBe
  name: 'sqlDeployUser'
  properties: {
    value: sqlDeployUser
  }
}
resource secretsqlDeployPwd 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVaultBe
  name: 'sqlDeployPwd'
  properties: {
    value: sqlDeployPwd
  }
}

resource secretWebAppNameBe 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVaultBe
  name: secretNamewebAppName
  properties: {
    value: webAppNameBe
  }
}

output keyVaultUri string = keyVaultFe.properties.vaultUri
