param publisherName string
param publisherEmail string
param subnetResourceId string
param apiHostname string
param keyVaultName string
param secretName string
param managedIdentityId string

var suffix = uniqueString(resourceGroup().id)
var apimName = concat('apim-',suffix)
var location = resourceGroup().location

resource apim 'Microsoft.ApiManagement/service@2019-12-01' = {
    name: apimName
    location: location
    properties: {
        virtualNetworkConfiguration: {
            subnetResourceId: subnetResourceId
        }
        hostnameConfigurations: [
            {
                type: 'Proxy'
                hostName: apiHostname
                keyVaultId: concat('https://managementhgvault.vault.azure.net/','secrets/${secretName}')
                negotiateClientCertificate: false
                defaultSslBinding: true
            }
        ]        
        virtualNetworkType: 'Internal'
        publisherEmail: publisherEmail
        publisherName: publisherName
    }    
    identity: {
        type: 'UserAssigned'
        userAssignedIdentities: {
            '${managedIdentityId}': {
                
            }
        }
    }
    sku: {
        name: 'Developer'
        capacity: 1
    }
}

output apimhostname string = concat(apimName,'.net')
output apimPrivateIp string = apim.properties.privateIPAddresses[0]