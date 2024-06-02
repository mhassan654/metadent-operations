@description('Server Name for Azure database for MySQL')
@minLength(1)
param sqlServerName string

@description('Database administrator login name')
@minLength(1)
param sqlAdminUser string

@description('Database administrator password')
@minLength(8)
@secure()
param sqlAdminPwd string 

@description('Fully Qualified DNS Private Zone')
param dnsZoneFqdn string = '${sqlServerName}.private.mysql.database.azure.com'

@description('Azure database for MySQL sku name ')
param skuName string

@description('Azure database for MySQL storage Size ')
param StorageSizeGB int = 20

@description('Azure database for MySQL storage Iops')
param StorageIops int = 360

@description('Azure database for MySQL pricing tier')
@allowed([
  'GeneralPurpose'
  'MemoryOptimized'
  'Burstable'
])
param SkuTier string = 'Burstable'

@description('MySQL version')
@allowed([
  '5.7'
  '8.0.21'
])
param mysqlVersion string

@description('Location for all resources.')
param location string = resourceGroup().location

@description('MySQL Server backup retention days')
param backupRetentionDays int = 7

@description('Geo-Redundant Backup setting')
param geoRedundantBackup string = 'Enabled'

@description('Virtual Network resource group name')
param vnetResourceGroupName string

@description('Subnet Name')
param subnetName string

module vnetModule '../virtual_networks/vnets.bicep' = {
  scope: resourceGroup(vnetResourceGroupName)
  name: 'vnetModule'
}

@description('Composing the subnetId')
var mysqlSubnetId = '${vnetModule.outputs.vnetResourceId}/subnets/${subnetName}'

resource dnszone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: dnsZoneFqdn
  location: 'global'
}

resource vnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: dnsZoneFqdn
  parent: dnszone
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnetModule.outputs.vnetResourceId
    }
  }
}

resource mysqlDbServer 'Microsoft.DBforMySQL/flexibleServers@2023-12-01-preview' = {
  name: sqlServerName
  location: location
  sku: {
    name: skuName
    tier: SkuTier
  }
  properties: {
    administratorLogin: sqlAdminUser
    administratorLoginPassword: sqlAdminPwd
    storage: {
      autoGrow: 'Enabled'
      iops: StorageIops
      storageSizeGB: StorageSizeGB
    }
    createMode: 'Default'
    version: mysqlVersion
    backup: {
      backupRetentionDays: backupRetentionDays
      geoRedundantBackup: geoRedundantBackup
    }
    highAvailability: {
      mode: 'Disabled'
    }
    network: {
      delegatedSubnetResourceId: mysqlSubnetId
      privateDnsZoneResourceId: dnszone.id
    }
  }
  dependsOn: [
    vnetLink
  ]
}

output location string = location
output name string = mysqlDbServer.name
output resourceGroupName string = resourceGroup().name
output resourceId string = mysqlDbServer.id
output mysqlHostname string = '${sqlServerName}.${dnszone.name}'
output mysqlSubnetId string = mysqlSubnetId
output vnetId string = vnetModule.outputs.vnetResourceId
output privateDnsId string = dnszone.id
output privateDnsName string = dnszone.name

