
param virtualNetworkName string
var location = resourceGroup().location
var subnetEnv = 'DEV'
var subnetSql = 'SQL'
var subnetWeb = 'WEB'

var subnetEnvAddressPrefix = '172.31.11.0/24'
var subnetSqlAddressPrefix = '172.31.12.0/24'
var subnetWebAddressPrefix = '172.31.13.0/24'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.31.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnetEnv
        properties: {
          addressPrefix: subnetEnvAddressPrefix
        }
      }
      {
        name: subnetSql
        properties: {
          addressPrefix: subnetSqlAddressPrefix
          delegations: [
            {
              name: 'delegation'
              properties: {
                serviceName: 'Microsoft.DBforMySQL/flexibleServers'
              }
            }
          ]
        }
      }
      {
        name: subnetWeb
        properties: {
          addressPrefix: subnetWebAddressPrefix
          delegations: [
            {
              name: 'delegation'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
        }
      }      
    ]
  }

  resource subnetENV 'subnets' existing = {
    name: subnetEnv
  }
  resource subnetSQL 'subnets' existing = {
    name: subnetSql
  }
  resource subnetWEB 'subnets' existing = {
    name: subnetWeb
  }    
}

output subnetSQL object = virtualNetwork::subnetSQL
output vnetResourceId string = virtualNetwork.id
output subnetEnvResourceId string = virtualNetwork::subnetENV.id
output subnetSqlResourceId string = virtualNetwork::subnetSQL.id
output subnetWebResourceId string = virtualNetwork::subnetWEB.id
