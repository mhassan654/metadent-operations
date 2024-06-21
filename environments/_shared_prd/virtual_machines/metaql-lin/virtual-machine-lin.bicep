@description('Username for the Virtual Machine.')
param adminUser string

@description('Password for the Virtual Machine.')
@minLength(12)
@secure()
param adminPwd string

@description('Unique DNS Name for the Public IP used to access the Virtual Machine.')
param dnsLabelPrefix string = toLower('${vmName}-${uniqueString(resourceGroup().id, vmName)}')

@description('Name for the Public IP used to access the Virtual Machine.')
param publicIpName string = 'metaql-lin-01-ip'

@description('Allocation method for the Public IP used to access the Virtual Machine.')
@allowed([
  'Dynamic'
  'Static'
])
param publicIPAllocationMethod string = 'Static'

@description('SKU for the Public IP used to access the Virtual Machine.')
@allowed([
  'Basic'
  'Standard'
])
param publicIpSku string = 'Standard'

@description('Size of the virtual machine.')
param vmSize string
@description('Name of the virtual machine.')
param vmName string

@description('Subscription Id')
var subscriptionId = subscription().subscriptionId

@description('Image resource group.')
param imageResourceGroup string
param imageName string

@description('Location for all resources.')
param location string = resourceGroup().location

var nicName = 'metaql-lin-01-nic'
var addressPrefix = '172.26.0.0/16'
var subnetName = 'Subnet'
var subnetPrefix = '172.26.1.0/24'
var virtualNetworkName = 'metaql-lin-01'
var networkSecurityGroupName = 'default-NSG'

resource publicIp 'Microsoft.Network/publicIPAddresses@2022-05-01' = {
  name: publicIpName
  location: location
  sku: {
    name: publicIpSku
  }
  properties: {
    publicIPAllocationMethod: publicIPAllocationMethod
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2022-05-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-SSH'
        properties: {
          priority: 1000
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '22'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '178.239.198.0/24'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
        }
      }
    ]
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2022-05-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIp.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)
          }
        }
      }
    ]
  }
  dependsOn: [

    virtualNetwork
  ]
}

resource vm 'Microsoft.Compute/virtualMachines@2022-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    priority: 'Spot'
    evictionPolicy: 'Deallocate'
    osProfile: {
      computerName: vmName
      adminUsername: adminUser
      adminPassword: adminPwd
    }
    storageProfile: {
      imageReference: {
        id: '/subscriptions/${subscriptionId}/resourceGroups/${imageResourceGroup}/providers/Microsoft.Compute/images/${imageName}'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
      dataDisks: [
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

output hostname string = publicIp.properties.dnsSettings.fqdn
