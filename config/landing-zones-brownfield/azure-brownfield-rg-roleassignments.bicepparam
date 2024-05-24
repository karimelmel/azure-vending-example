using '../../infra-as-code/archetypes/brownfield/brownfield.bicep'

param pimResourceGroupRoleAssignments = [
    {
      resourceGroupName: 'EXAMPLE-RG'
      principalId: ''
      definition: 'Owner'
      subscriptionId: ''
    }
    {
      resourceGroupName: 'EXAMPLE-RG'
      principalId: ''
      definition: 'Contributor'
      subscriptionId: ''
    }
    {
      resourceGroupName: 'User Access Administrator'
      principalId: ''
      definition: 'Owner'
      subscriptionId: ''
    }
  ]
