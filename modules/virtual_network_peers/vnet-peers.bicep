param sourceNetworkname string
param destinationResourceGroupName string
param destinationNetworkname string

// resource sourceNetwork 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
//   name: sourceNetworkname
// }

// resource destinationNetwork 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
//   name: destinationNetworkname
// }

// resource sourceToDestinationPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
//   name: '${sourceNetworkname}-To-${destinationNetworkname}'
//   parent: sourceNetwork
//   properties: {
//     allowForwardedTraffic: true
//     allowGatewayTransit: true
//     remoteVirtualNetwork: {
//       id: destinationNetwork.id
//     }
//   }
// }

// resource destinationToSourcePeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
//   name: '${destinationNetworkname}-To-${sourceNetworkname}'
//   parent: destinationNetwork
//   properties: {
//     allowForwardedTraffic: true
//     allowGatewayTransit: true
//     remoteVirtualNetwork: {
//       id: sourceNetwork.id
//     }
//   }
// }
