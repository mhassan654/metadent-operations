param location string = resourceGroup().location

var virtualNetworkName = 'metadent-afr-prd-01'
var subnet1Name = 'PRD'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.30.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: '172.30.10.0/24'
        }
      }
    ]
  }

  resource subnet1 'subnets' existing = {
    name: subnet1Name
  }
}

output subnet1ResourceId string = virtualNetwork::subnet1.id
