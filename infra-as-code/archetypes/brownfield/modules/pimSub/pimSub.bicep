targetScope = 'subscription'

@sys.description('The ID of the user that will be assigned the eligible role.')
param principalId string

@sys.description('The ID of the role that will be eligible.')
param roleDefinitionId string

@sys.description('The time the eligible role assignment will be available.')
param startTime string = utcNow()

@sys.description('Used for generting a random name for the eligible role assignment so that it can be updated on every run without conflicting name.')
param rand string = newGuid()

@sys.description('The duration of the eligible role assignment.')
param eligibleRoleAssignmentExpiration object = {
  duration: 'P180D'
  type: 'AfterDuration'
}

// Get the required full role id in the format 'subscriptions/<subscription ID>/providers/Microsoft.Authorization/roleDefinitions/<role ID>'
resource roleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: roleDefinitionId
}

// Create eligibile pim assignmen for a principal
resource pimAssignment 'Microsoft.Authorization/roleEligibilityScheduleRequests@2022-04-01-preview' = {
  name: rand
  properties: {
    principalId: principalId
    requestType: 'AdminUpdate'
    roleDefinitionId: roleDefinition.id
    scheduleInfo: {
      expiration: eligibleRoleAssignmentExpiration
      startDateTime: startTime
    }
  }
}

output roleId string = roleDefinition.id
