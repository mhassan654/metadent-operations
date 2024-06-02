param appName string
param appHostName string
param certificateThumbprint string

resource functionAppCustomHostEnable 'Microsoft.Web/sites/hostNameBindings@2020-06-01' = {
  name: '${appName}/${appHostName}'
  properties: {
    sslState: 'SniEnabled'
    thumbprint: certificateThumbprint
  }
}
