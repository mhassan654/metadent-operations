@description('Specifies the name of the key vault.')
@minLength(3)
param keyVaultName string = 'uriel-dev-be-01'

@description('Specifies the Azure location where the key vault should be created.')
param location string = resourceGroup().location

@description('Specifies whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault.')
param enabledForDeployment bool = true

@description('Specifies whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys.')
param enabledForDiskEncryption bool = true

@description('Specifies whether Azure Resource Manager is permitted to retrieve secrets from the key vault.')
param enabledForTemplateDeployment bool = true

@description('Specifies the Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. Get it by using Get-AzSubscription cmdlet.')
param tenantId string = subscription().tenantId

@description('Specifies the object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies. Get it by using Get-AzADUser or Get-AzADServicePrincipal cmdlets.')
param objectId string ='78c9a6ad-d8cb-461f-92a6-e721b3b13b5e'

@description('Specifies the permissions to keys in the vault.')
param keysPermissions array = [
  'list','get','create','update','import','delete','recover','backup','restore','all', 'encrypt', 'decrypt', 'wrapKey', 'unwrapKey', 'sign', 'verify','purge'
]

@description('Specifies the permissions to secrets in the vault.')
param secretsPermissions array = [
  'list','get','set','delete','recover','backup','restore','purge'
]

@description('Specifies whether the key vault is a standard vault or a premium vault.')
@allowed([
  'standard'
  'premium'
])
param skuName string = 'standard'

@description('Specifies the name of the secret that you want to create.')
param resourceGroupNameSecretName string = 'resourceGroupName'

@description('Specifies the value of the secret that you want to create.')
@secure()
param secretValue string ='uriel-prd-rg'

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    enabledForDeployment: enabledForDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enabledForTemplateDeployment: enabledForTemplateDeployment
    tenantId: tenantId
    accessPolicies: [
      {
        objectId: objectId
        tenantId: tenantId
        permissions: {
          keys: keysPermissions
          secrets: secretsPermissions
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

resource secret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: kv
  name: resourceGroupNameSecretName
  properties: {
    value: secretValue
  }
}


output location string = location
output name string = kv.name
output resourceGroupName string = resourceGroup().name
output resourceId string = kv.id
