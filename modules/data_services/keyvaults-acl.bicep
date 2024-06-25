
param keyVaultName string
@description('The list of object IDs for users, groups, or applications to assign as Key Vault administrators.')
param objectIdList array = [
  '14685cef-d43c-48fa-ab24-2e0373c16653' // DEV_ADMINS
  '804da5c2-e83b-4cbe-9695-267014b6775d' // service connection app reg
  'a7d73e46-7259-4b0a-be5c-23c84f26c6a4' // service connection app reg Metadent Operations  
]
resource keyVaultAccessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2021-11-01-preview' = {
  name: '${keyVaultName}/add'
  properties: {
    accessPolicies: [
      for objectId in objectIdList: {
        tenantId: subscription().tenantId
        objectId: objectId
        permissions: {
          secrets: ['get', 'list']
        }
      }
    ]
  }
}
