targetScope = 'managementGroup'

@metadata({
  example: [
    {
      principalId: '35e5ed19-25f3-43d5-a6c5-59ea49b608f7'
      definition: 'Contributor'
    }
  ]
})
@sys.description('Array of objects containing eligible role assignments for the subscription.')
param pimSubscriptionRoleAssignments array = []

@metadata({
  example: [
    {
      resourceGroupName: 'rg-test-d-we'
      principalId: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      definition: 'Contributor'
    }
  ]
})
@sys.description('Array of objects containing eligible role assignments for a resource group in the subscription.')
param pimResourceGroupRoleAssignments array = []

// Module wrapper so that we can deploy to the subscription scope using the output subscription id from lzSubscription
module wrapper 'subscriptionWrapper.bicep' = {
  name: '${deployment().name}-wrapper'
  params: {
    pimSubscriptionRoleAssignments: pimSubscriptionRoleAssignments
    pimResourceGroupRoleAssignments: pimResourceGroupRoleAssignments
  }
}

output tenant_id string = tenant().tenantId
