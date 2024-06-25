param mysqlServerName string
param databaseName string

resource mysqlserver 'Microsoft.DBforMySQL/flexibleServers@2021-12-01-preview' existing = {
  name: mysqlServerName
}

resource database 'Microsoft.DBforMySQL/flexibleServers/databases@2021-12-01-preview' = {
  parent: mysqlserver
  name: databaseName
  properties: {
    charset: 'utf8'
    collation: 'utf8_general_ci'
  }
}
