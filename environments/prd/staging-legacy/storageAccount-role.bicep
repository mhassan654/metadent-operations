
param storageAccountName string

// Service Principal ID - Metadent Operations
var servicePrincipalId = 'a7d73e46-7259-4b0a-be5c-23c84f26c6a4'

// Role Definition ID for 'Storage Blob Data Contributor'
// This ID is constant across all Azure Subscriptions
var roleDefinitionId = any('/providers/Microsoft.Authorization/roleDefinitions/ba92f5b4-2d11-453d-a403-e96b0029c9fe')


// Generate a unique role assignment ID
var roleAssignmentName = guid(storageAccountName, servicePrincipalId, roleDefinitionId)

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-04-01' existing = {
  name: storageAccountName
}


resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: storageAccount
  name: roleAssignmentName
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: servicePrincipalId
    principalType: 'ServicePrincipal'
  }
}
