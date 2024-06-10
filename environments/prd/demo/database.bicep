param mysqlServerResourceGroupName string
param mysqlServerName string
param databaseName string

module databaseModule 'databaseModule.bicep' = {
  name: 'databaseModule'
  params: {
    mysqlServerName: mysqlServerName
    databaseName: databaseName
  }
  scope: resourceGroup(mysqlServerResourceGroupName)
}
