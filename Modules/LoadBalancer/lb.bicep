param lbName string = 'myLB'
param vnetId string
param frontendIPConfigName string = 'frontendIPConfig'
param backendPoolName string = 'backendPool'
param probeName string = 'probe'
param lbRuleName string = 'lbRule'
param backendPort int = 8080
param location string ='East US'


targetScope= 'resourceGroup'

resource lb 'Microsoft.Network/loadBalancers@2021-02-01' = {
  name: lbName
  location: location
  properties: {
    frontendIPConfigurations: [
      {
        name: frontendIPConfigName
        properties: {
          privateIPAddress: '10.0.0.9'
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: '${vnetId}/subnets/default'
          }
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    backendAddressPools: [
      {
        name: backendPoolName
      }
    ]
    probes: [
      {
        name: probeName
        properties: {
          protocol: 'Tcp'
          port: backendPort
        }
      }
    ]
    loadBalancingRules: [
      {
        name: lbRuleName
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', lbName, frontendIPConfigName)
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', lbName, backendPoolName)
          }
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', lbName, probeName)
          }
          protocol: 'Tcp'
          frontendPort: 80
          backendPort: backendPort
        }
      }
    ]
  }
}

output lbId string = lb.id
