@description('Name of the Key Vault')
@minLength(3)
param keyVaultNameBe string
var secretResourceGroupName = 'resourceGroupName'

resource keyVaultBe 'Microsoft.KeyVault/vaults@2021-10-01' existing = {
  name: keyVaultNameBe
}

resource resourceGroupName 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVaultBe
  name: secretResourceGroupName
  properties: {
    value: resourceGroup().name
  }
}
