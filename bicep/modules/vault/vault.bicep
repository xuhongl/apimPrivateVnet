param vaultName string
param apimIdentity string

var identityName = 'apggwuseridentity'
var location = resourceGroup().location

// Identity used in Application Gateway
resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: identityName
  location: location
}

resource accessPolicies 'Microsoft.KeyVault/vaults/accessPolicies@2019-09-01' = { 
  name: any('${vaultName}/add')
  properties: {
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: reference(identity.id).principalId
        permissions: {
          secrets: [
            'get'
            'list'
          ]
        }
      }
      {
        tenantId: subscription().tenantId
        objectId: apimIdentity
        permissions: {
          secrets: [
            'get'
            'list'
          ]
          certificates: [
            'list'
          ]
        }        
      }
    ]
  }
}