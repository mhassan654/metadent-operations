@description('Provide a prefix for creating resource names.')
param serverName string = 'metadent-sql-afr-dev-01'
param dnsName string = 'metadent-sqldns-dev-01'
param mysqlServerHostName string = serverName


@description('Provide the location for all the resources.')
param location string = resourceGroup().location

@description('Provide the administrator login username for the flexible server.')
param administratorLogin string = 'mysqladmin'

@description('Provide the administrator login password for the flexible server.')
@secure()
param administratorLoginPassword string = newGuid()


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

var vnetResourceGroupName = 'network-afr-dev-rg'
module vnetModule '../../_shared_dev/virtual_networks/vnets.bicep' = {
  scope: resourceGroup(vnetResourceGroupName)
  name: 'vnetModule'
}

@description('The name of the SKU, such as Standard_D32ds_v4.')
param skuName string = 'Standard_B1s'

param backupRetentionDays int = 7
@allowed([
  'Disabled'
  'Enabled'
])
param geoRedundantBackup string = 'Disabled'

// MySQL private endpoint
resource privateMySQLEndpoint 'Microsoft.Network/privateEndpoints@2022-09-01' = {
  name: dnsName
  location: location
  properties: {
    subnet: vnetModule.outputs.subnetSQL
    customNetworkInterfaceName: 'nic-${dnsName}'
    privateLinkServiceConnections: [
      {
        name: 'pl-${dnsName}'
        properties: {
          privateLinkServiceId: mySqlserver.id
          groupIds: [
            'mysqlServer'
          ]
          privateLinkServiceConnectionState: {
            status: 'Approved'
            description: 'Auto-Approved'
            actionsRequired: 'None'
          }
        }
      }
    ]
  }
}

resource privateMySQLDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: mysqlServerHostName
  location: 'global'
}

// MySQL private dns zone virtual network link
resource privateMySQLDNSZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'vnl-mysql-${dnsName}'
  location: 'global'
  parent: privateMySQLDNSZone
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnetModule.outputs.vnetResourceId
    }
  }
}

// MySQL private dns zone group
resource privateMySQLDNSZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-11-01' = {
  name: 'default'
  parent: privateMySQLEndpoint
  properties: {
    privateDnsZoneConfigs: [
      {
        name: mysqlServerHostName
        properties: {
          privateDnsZoneId: privateMySQLDNSZone.id
        }
      }
    ]
  }
}

resource mySqlserver 'Microsoft.DBforMySQL/flexibleServers@2021-12-01-preview' = {
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
    network: {
      delegatedSubnetResourceId: vnetModule.outputs.subnetSqlResourceId
      privateDnsZoneResourceId: privateMySQLDNSZone.id   
    }
    backup: {
      backupRetentionDays: backupRetentionDays
      geoRedundantBackup: geoRedundantBackup
    }
  }
}

output mysqlserver object = mySqlserver
