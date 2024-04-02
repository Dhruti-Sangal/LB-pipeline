// targetScope= 'subscription'

param vmName string = 'vm7648'
param vnetName string = 'vnet9876'
param location string = 'East US'
param lbName string = 'myLB'
param frontendIPConfigName string = 'frontendIPConfig'
param backendPoolName string = 'backendPool'
param probeName string = 'probe'
param lbRuleName string = 'lbRule'
param backendPort int = 8080
param resourceGroupName1 string = 'lbvm'
param resourceGroupName2 string = 'vnet'


// param rgName1 string = 'NewRG33'
// param rgName2 string = 'NewRG44'

// resource newrg1 'Microsoft.Resources/resourceGroups@2023-07-01'={
//   name:rgName1
//   location:location
  
// }

// resource newrg2 'Microsoft.Resources/resourceGroups@2023-07-01'={
//   name:rgName2
//   location:location
// }
module vnetModule 'Modules/VirtualNetwork/vnet.bicep' ={
  name: 'vnetModule' 
  scope:resourceGroup(resourceGroupName2)
  params: {
    vnetName: vnetName
    location: location
  }
}

module vmModule 'Modules/VirtualMachine/vm.bicep' = {
  name: 'vmModule'
  scope:resourceGroup(resourceGroupName1)
  params: {
    vmName: vmName
    vnetId: vnetModule.outputs.vnetId
    location: location
  }
}

module lb 'Modules/LoadBalancer/lb.bicep' = {
  name: 'lb'
  scope:resourceGroup(resourceGroupName1)
  params: {
    lbName: lbName
    frontendIPConfigName: frontendIPConfigName
    backendPoolName: backendPoolName
    probeName: probeName
    lbRuleName: lbRuleName
    backendPort: backendPort
    location:location
    vnetId:vnetModule.outputs.vnetId
  }
}
output vmId string = vmModule.outputs.vmId
output vnetId string = vnetModule.outputs.vnetId
// output lbId string = lb.outputs.id
