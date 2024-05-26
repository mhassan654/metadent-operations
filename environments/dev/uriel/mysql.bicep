@description('Provide a prefix for creating resource names.')
param resourceNamePrefix string = 'uriel-sql-dev-01'

@description('Provide the location for all the resources.')
param location string = resourceGroup().location

@description('Provide the administrator login username for the flexible server.')
param administratorLogin string = 'uriel-dev-01'

@description('Provide the administrator login password for the flexible server.')
@secure()
param administratorLoginPassword string = 'UrielSqlUser!'

@description('Provide an array of firewall rules to apply to the flexible server.')
param firewallRules array = [
  {
    name: 'rule1'
    startIPAddress: '192.168.0.1'
    endIPAddress: '192.168.0.255'
  }
  {
    name: 'rule2'
    startIPAddress: '192.168.1.1'
    endIPAddress: '192.168.1.255'
  }
]

@description('The tier of the particular SKU. High availability mode is available only in the GeneralPurpose and MemoryOptimized SKUs.')
@allowed([
  'Burstable'
  'GeneralPurpose'
  'MemoryOptimized'
])
param serverEdition string = 'Burstable'

@description('Server version')
@allowed([
  '5.7'
])
param version string = '5.7'

// param availabilityZone string = '0'

@description('High availability mode for a server: Disabled, SameZone, or ZoneRedundant.')
@allowed([
  'Disabled'
  'SameZone'
  'ZoneRedundant'
])
param haEnabled string = 'Disabled'

@description('The availability zone of the standby server.')
param standbyAvailabilityZone string = '2'

param storageSizeGB int = 20
param storageIops int = 360
@allowed([
  'Enabled'
  'Disabled'
])
param storageAutogrow string = 'Enabled'

@description('The name of the SKU, such as Standard_D32ds_v4.')
param skuName string = 'Standard_B1s'

param backupRetentionDays int = 7
@allowed([
  'Disabled'
  'Enabled'
])
param geoRedundantBackup string = 'Disabled'

param serverName string = '${resourceNamePrefix}'
param databaseName string = 'uriel_db'

resource server 'Microsoft.DBforMySQL/flexibleServers@2021-12-01-preview' = {
  location: location
  name: serverName
  sku: {
    name: skuName
    tier: serverEdition
  }
  properties: {
    version: version
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    highAvailability: {
      mode: haEnabled
      standbyAvailabilityZone: standbyAvailabilityZone
    }
    storage: {
      storageSizeGB: storageSizeGB
      iops: storageIops
      autoGrow: storageAutogrow
    }
    backup: {
      backupRetentionDays: backupRetentionDays
      geoRedundantBackup: geoRedundantBackup
    }
  }
}

@batchSize(1)
resource firewallRule 'Microsoft.DBforMySQL/flexibleServers/firewallRules@2021-12-01-preview' = [for rule in firewallRules: {
  parent: server
  name: rule.name
  properties: {
    startIpAddress: rule.startIPAddress
    endIpAddress: rule.endIPAddress
  }
}]

resource database 'Microsoft.DBforMySQL/flexibleServers/databases@2021-12-01-preview' = {
  parent: server
  name: databaseName
  properties: {
    charset: 'utf8'
    collation: 'utf8_general_ci'
  }
}
