@description('Name of the Key Vault')
@minLength(3)
param keyVaultNameFe string = 'metadent-dev-fe-01'
param keyVaultNameBe string = 'metadent-dev-be-01'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('The list of object IDs for users, groups, or applications to assign as Key Vault administrators.')
param objectIdListFe array = [
  '78c9a6ad-d8cb-461f-92a6-e721b3b13b5e'
]
param objectIdListBe array = [
  '78c9a6ad-d8cb-461f-92a6-e721b3b13b5e'
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
      for objectId in objectIdListFe: {
        tenantId: subscription().tenantId
        objectId: objectId
        permissions: {
          keys: ['get', 'list', 'create', 'update', 'import', 'delete', 'recover', 'backup', 'restore']
          secrets: ['get', 'list', 'set', 'delete', 'recover', 'backup', 'restore']
          certificates: ['get', 'list', 'delete', 'create', 'import', 'update', 'managecontacts', 'getissuers', 'listissuers', 'setissuers', 'deleteissuers', 'manageissuers', 'recover']
          storage: ['get', 'list', 'delete', 'set', 'update', 'regeneratekey', 'setsas', 'listsas', 'getsas', 'deletesas']
        }
      }
    ]
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
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
      for objectId in objectIdListBe: {
        tenantId: subscription().tenantId
        objectId: objectId
        permissions: {
          keys: ['get', 'list', 'create', 'update', 'import', 'delete', 'recover', 'backup', 'restore']
          secrets: ['get', 'list', 'set', 'delete', 'recover', 'backup', 'restore']
          certificates: ['get', 'list', 'delete', 'create', 'import', 'update', 'managecontacts', 'getissuers', 'listissuers', 'setissuers', 'deleteissuers', 'manageissuers', 'recover']
          storage: ['get', 'list', 'delete', 'set', 'update', 'regeneratekey', 'setsas', 'listsas', 'getsas', 'deletesas']
        }
      }
    ]
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
  }
}

output keyVaultUri string = keyVaultFe.properties.vaultUri
