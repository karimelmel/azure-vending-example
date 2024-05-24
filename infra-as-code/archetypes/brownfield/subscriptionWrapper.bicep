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

// Used to convert role name to role definition ID.
var roleMap = loadJsonContent('../../modules/roleMap/roleMap.json')

// Deploy eligible subscripton pim role assignments.
module pimAssignmentSub 'modules/pimSub/pimSub.bicep' =  [for assignment in pimSubscriptionRoleAssignments: {
  name: '${deployment().name}-pimAssigSub-${substring(uniqueString(assignment.principalId, assignment.definition), 0, 6)}'
  scope: subscription(assignment.subscriptionId)
  params: {
    roleDefinitionId: roleMap[assignment.definition].id
    principalId: assignment.principalId
    eligibleRoleAssignmentExpiration: {
      duration: 'P365D'
      type: 'AfterDuration'
    }
  }
}]

// Deploy eligible resource group pim role assignments.
module pimAssignmentRg 'modules/pimRg/pimRg.bicep' =  [for (assignment, index) in pimResourceGroupRoleAssignments: {
  name: '${assignment.resourceGroupName}-${index}'
  scope: resourceGroup(assignment.subscriptionId, assignment.resourceGroupName)
  params: {
    roleDefinitionId: roleMap[assignment.definition].id
    principalId: assignment.principalId
    eligibleRoleAssignmentExpiration: {
      duration: 'P180D'
      type: 'AfterDuration'
    }
  }
}]
