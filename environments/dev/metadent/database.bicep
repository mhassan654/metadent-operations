var mysqlServerResourceGroupName = 'sql-afr-dev-rg'
var mysqlServerName = 'metadent-sql-afr-dev-01'
var databaseName = 'metadentdev01'

module databaseModule 'databaseModule.bicep' = {
  name: 'databaseModule'
  params: {
    mysqlServerName: mysqlServerName
    databaseName: databaseName
  }
  scope: resourceGroup(mysqlServerResourceGroupName)
}
