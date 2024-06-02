param appName string
param dnsZone string
param hostPlanId string
param location string

resource AppCustomHost 'Microsoft.Web/sites/hostNameBindings@2020-06-01' = {
  name: dnsZone
  properties: {
    hostNameType: 'Verified'
    sslState: 'Disabled'
    customHostNameDnsRecordType: 'CName'
    siteName: appName
  }
}

resource AppCustomHostCertificate 'Microsoft.Web/certificates@2020-06-01' = {
  name: dnsZone
  location: location
  dependsOn: [AppCustomHost]
  properties: any({
    serverFarmId: hostPlanId
    canonicalName: dnsZone
  })
}

// we need to use a module to enable sni, as ARM forbids using resource with this same type-name combination twice in one deployment.
module AppCustomHostEnable './sni-enable.bicep' = {
  name: '${appName}-sni-enable'
  params: {
    appName: appName
    appHostName: AppCustomHostCertificate.name
    certificateThumbprint: AppCustomHostCertificate.properties.thumbprint
  }
}
