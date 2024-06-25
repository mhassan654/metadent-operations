@description('Name of the Key Vault')
@minLength(3)
param keyVaultName string

param smtpUsername string
@secure()
param smtpPassword string

@description('Location for all resources.')
param location string = resourceGroup().location

@description('The list of object IDs for users, groups, or applications to assign as Key Vault administrators.')
param objectIdList array = [
  '14685cef-d43c-48fa-ab24-2e0373c16653' // DEV_ADMINS
  '804da5c2-e83b-4cbe-9695-267014b6775d' // service connection app reg
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
  name: 'smtpUsername'
  properties: {
    value: smtpUsername
  }
}

resource secretsqlServerResourceGroup 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'smtpPassword'
  properties: {
    value: smtpPassword
  }
}



output keyVaultUri string = keyVault.properties.vaultUri
