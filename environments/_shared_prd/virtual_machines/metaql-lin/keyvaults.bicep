@description('Specifies the name of the key vault.')
param keyVaultName string ='ado-agent-lin-prd-01'

@description('Specifies the Azure location where the key vault should be created.')
param location string = resourceGroup().location

@description('Specifies whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault.')
param enabledForDeployment bool = false

@description('Specifies whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys.')
param enabledForDiskEncryption bool = false

@description('Specifies whether Azure Resource Manager is permitted to retrieve secrets from the key vault.')
param enabledForTemplateDeployment bool = false

@description('Specifies the Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. Get it by using Get-AzSubscription cmdlet.')
param tenantId string = subscription().tenantId

@description('Specifies whether the key vault is a standard vault or a premium vault.')
@allowed([
  'standard'
  'premium'
])
param skuName string = 'standard'

@description('Username for the Virtual Machine.')
param adminUser string

@description('Password for the Virtual Machine.')
@secure()
param adminPwd string

@description('The list of object IDs for users, groups, or applications to assign as Key Vault administrators.')
param objectIdList array = [
  '14685cef-d43c-48fa-ab24-2e0373c16653' // DEV_ADMINS
  '804da5c2-e83b-4cbe-9695-267014b6775d' // service connection app reg
]

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    enabledForDeployment: enabledForDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enabledForTemplateDeployment: enabledForTemplateDeployment
    tenantId: tenantId
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    accessPolicies: [
      for objectId in objectIdList: {
        tenantId: subscription().tenantId
        objectId: objectId
        permissions: {
          secrets: ['get', 'list']
        }
      }
    ]
    sku: {
      name: skuName
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}

resource secretadminUser 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: kv
  name: 'adminUser'
  properties: {
    value: adminUser
  }
}

resource secretadminPwd 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: kv
  name: 'adminPwd'
  properties: {
    value: adminPwd
  }
}

output location string = location
output name string = kv.name
output resourceGroupName string = resourceGroup().name
output resourceId string = kv.id
