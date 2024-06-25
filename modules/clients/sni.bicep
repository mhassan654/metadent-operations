param appName string // from webApp.name
param dnsName string // the full endpoint for this web app (xyz.domain.com)
param certificateThumbprint string // from certificate.properties.thumbprint

resource hostBinding 'Microsoft.Web/sites/hostNameBindings@2020-06-01' = {
  name: '${appName}/${dnsName}'
  properties: {
    sslState: 'SniEnabled'
    thumbprint: certificateThumbprint
  }
}
