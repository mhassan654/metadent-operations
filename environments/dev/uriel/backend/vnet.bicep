param location string = resourceGroup().location

var virtualNetworkName = 'uriel-vnet-prd-01'
var subnet1Name = 'PRD'
var subnet2Name= 'uriel-sql-dev-01'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-11-01'={
  name:virtualNetworkName
  location:location
  properties:{
    addressSpace:{
      addressPrefixes:[
        '172.16.0.0/16'
      ]
    }

    subnets:[
      {
        name: subnet1Name
        properties:{
          addressPrefix: '172.16.1.0/16'
        }
      }

      {
        name: subnet2Name
        properties:{
          addressPrefix: '172.16.2.0/16'
        }
      }
    ]
  }

  resource subnet1 'subnets' existing={name:subnet1Name}
  resource subnet2 'subnets' existing={name:subnet2Name}
}

output subnet1ResourceId string= virtualNetwork::subnet1.id
output subnet2ResourceId string= virtualNetwork::subnet2.id
