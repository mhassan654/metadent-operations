@description('Base name of the resource such as web app name and app service plan ')
@minLength(2)
param webAppNameFrontend string
param webAppNameBackend string
param dnsZoneFrontend string
param dnsZoneBackend string
param appServicePlanResourceGroupName string
param appServicePlanName string
param vnetResourceGroupName string
param vnetName string

@description('The Runtime stack of current web app')
param linuxFxVersionFe string = 'php|8.2'
param linuxFxVersionBe string = 'php|8.2'

@description('Location for all resources.')
var location = resourceGroup().location
var subnetName = 'WEB'

module appServicePlanModule '../../_shared_dev/app_service_plans/asp.bicep' = {
  scope: resourceGroup(appServicePlanResourceGroupName)
  name: 'appServicePlanModule'
  params: {
    sku: 'b2'
    appServicePlanName: appServicePlanName
  }
}

resource vnetResource 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
  scope: resourceGroup(vnetResourceGroupName)
  name: vnetName
}

var subnetResourceId = '${vnetResource.id}/subnets/${subnetName}'

resource webAppFe 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppNameFrontend
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlanModule.outputs.appServicePlanId
    siteConfig: {
      linuxFxVersion: linuxFxVersionFe
      ftpsState: 'FtpsOnly'
    }
    httpsOnly: true
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource webAppBe 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppNameBackend
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlanModule.outputs.appServicePlanId
    virtualNetworkSubnetId: subnetResourceId 
    siteConfig: {
      linuxFxVersion: linuxFxVersionBe
      ftpsState: 'FtpsOnly'
      appCommandLine: 'curl -o /home/default https://raw.githubusercontent.com/ossentoo/nginx/main/default;curl -o /home/start.sh https://raw.githubusercontent.com/ossentoo/nginx/main/start.sh;chmod +x /home/start.sh;/home/start.sh'
    }    
    httpsOnly: true
    vnetRouteAllEnabled: true    
  }
  identity: {
    type: 'SystemAssigned'
  }
}


// Front end certificate
resource hostBindingFe 'Microsoft.Web/sites/hostNameBindings@2022-09-01' = {
  parent: webAppFe
  name: dnsZoneFrontend
  properties: {
    hostNameType: 'Verified'
    sslState: 'Disabled'
    customHostNameDnsRecordType: 'CName'
    siteName: dnsZoneFrontend
  }
}

resource certificateFe 'Microsoft.Web/certificates@2022-09-01' = {
  name: dnsZoneFrontend
  location: resourceGroup().location
  dependsOn: [
    hostBindingFe
  ]
  properties: any({
    serverFarmId: appServicePlanModule.outputs.appServicePlanId
    canonicalName: dnsZoneFrontend
  })
}

module hostEnableFe 'SNI.bicep' = {
  name: 'enableSNIFe'
  params: {
    appName: webAppFe.name
    dnsName: dnsZoneFrontend
    certificateThumbprint: certificateFe.properties.thumbprint
  }
}


// Backend certificate
resource hostBindingBe 'Microsoft.Web/sites/hostNameBindings@2022-09-01' = {
  parent: webAppBe
  name: dnsZoneBackend
  properties: {
    hostNameType: 'Verified'
    sslState: 'Disabled'
    customHostNameDnsRecordType: 'CName'
    siteName: dnsZoneBackend
  }
}

resource certificateBe 'Microsoft.Web/certificates@2022-09-01' = {
  name: dnsZoneBackend
  location: resourceGroup().location
  dependsOn: [
    hostBindingBe
  ]
  properties: any({
    serverFarmId: appServicePlanModule.outputs.appServicePlanId
    canonicalName: dnsZoneBackend
  })
}

module hostEnableBe 'SNI.bicep' = {
  name: 'enableSNIBe'
  params: {
    appName: webAppBe.name
    dnsName: dnsZoneBackend
    certificateThumbprint: certificateBe.properties.thumbprint
  }
}
