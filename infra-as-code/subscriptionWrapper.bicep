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

param pimResourceGroupEligibleRoleAssignmentExpiration object = {
  duration: 'P180D'
  type: 'AfterDuration'
}

@sys.description('The subscription the resources will be deployed to.')
param subscriptionId string

@description('Name of the Budget. It should be unique within a subscription.')
param budgetName string

@sys.description('The total amount of cost or usage to track with the budget in NOK per month.')
param budgetAmount int

@sys.description('The date the subscription budget will start. It must be the first of the month in YYYY-MM-DD format. A future start date shouldnt be more than three months in the future.')
param budgetStartDate string = '2024-01-01'

@sys.description('The list of email addresses to send the budget notification to when the threshold is exceeded.')
param budgetContactEmails array = []

@sys.description('The list of subscription owners that will be granted default assignments to the subscription.')
param subscriptionOwners array = []

@metadata({
  example: [
    {
      principalId: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      definition: 'Contributor'
    }
  ]
})
@sys.description('The list of additional PIM role assignments that will be granted to the subscription.')
param pimAdditionalSubscriptionRoleAssignments array = []

@sys.description('Flag to enable DNS setup')
param deployDnsZone bool = false

@sys.description('The DNS zone resource group name')
param dnsResourceGroupName string = ''

@sys.description('Location the resources will be deployed to.')
param location string = 'westeurope'

@description('Specifies the dns zone name. This parameter value is the subdomain part of the zone name which format is: <subdomain>.<environment>-lz.az.example.com')
param dnsZoneName string = ''

@description('Specifies resource environment')
param environment string = 'd'

@description('Specifies the parent dns zone name. This parameter value is the domain part of the zone name. By default, value is calculated with the parameter environment as: <environment>-lz.az.example.com')
param parentDnsZoneName string = '${environment}-lz.az.example.com'

@allowed([
  'Public'
  'Private'
])
@sys.description('The type of this DNS zone, default set to Public.')
param zoneType string = 'Public'

@description('Connectivity subscription Id. Used to update NS records in parent zone.')
param connectivitySubscriptionId string = ''

@description('Existing connectivity DNS resource group name. Used to update NS records in parent zone.')
param connetivityDnsResourceGroupName string = ''

@sys.description('Email address which will get notifications from Microsoft Defender for Cloud by the configurations defined in this security contact.	')
param securityContactEmail string

@allowed([
'AccountAdmin'
'Contributor'
'Owner'
'ServiceAdmin'])
@sys.description('Defines whether to send email notifications from Microsoft Defender for Cloud to persons with specific RBAC roles on the subscription.')
param securityContactNotificationsByRole array

@allowed([
  'On'
  'Off'
])
@sys.description('Defines if email notifications will be sent about new security alerts')
param securityContactAlertState string

@allowed([
  'Low'
  'Medium'
  'High'
])
@sys.description('Defines the minimal alert severity which will be sent as email notifications.')
param securityContactAlertMinimalSeverity string

// Used to convert role name to role definition ID.
var roleMap = loadJsonContent('modules/roleMap/roleMap.json')

// Deploy eligible pim role assignment.
module pimAssignmentSub 'modules/pimSub/pimSub.bicep' =  [for (assignment, index) in pimSubscriptionRoleAssignments: {
  name: '${deployment().name}-pimAssignSub-${index}'
  scope: subscription(subscriptionId)
  params: {
    roleDefinitionId: roleMap[assignment.definition].id
    principalId: assignment.principalId
  }
}]

// Deploy eligible resource group pim role assignments.
module pimAssignmentRg 'modules/pimRg/pimRg.bicep' =  [for (assignment, index) in pimResourceGroupRoleAssignments: {
  name: '${assignment.resourceGroupName}-${index}'
  scope: resourceGroup(assignment.subscriptionId, assignment.resourceGroupName)
  params: {
    roleDefinitionId: roleMap[assignment.definition].id
    principalId: assignment.principalId
    eligibleRoleAssignmentExpiration: pimResourceGroupEligibleRoleAssignmentExpiration
  }
}]

// Deploy subscription budget
module budget 'modules/budget/budget.bicep' = {
  name: '${deployment().name}-budget'
  scope: subscription(subscriptionId)
  params: {
    budgetName: budgetName
    budgetAmount: budgetAmount
    budgetStartDate: budgetStartDate
    budgetContactEmails: budgetContactEmails
  }
}

// Deploy subscription owners default PIM assignments.
module pimAssignmentSubscriptionOwners 'modules/pimSub/pimSub.bicep' = [for (owner, index) in subscriptionOwners: {
  name: '${deployment().name}-pim-owner-${index}'
  scope: subscription(subscriptionId)
  params: {
    roleDefinitionId: roleMap['[EXAMPLE] Subscription Owner'].id
    principalId: owner
  }
}]

// Deploy subscription owners default Key Vault Administrator PIM assignments.
module pimAssignmentKeyVaultOfficers 'modules/pimSub/pimSub.bicep' = [for (owner, index) in subscriptionOwners: {
  name: '${deployment().name}-pim-kv-${index}'
  scope: subscription(subscriptionId)
  params: {
    roleDefinitionId: roleMap['Key Vault Administrator'].id
    principalId: owner
  }
}]

// Deploy subscription owners default Storage Blob Data Owner PIM assignments.
module pimAssignmentStorageAccountContributor 'modules/pimSub/pimSub.bicep' = [for (owner, index) in subscriptionOwners: {
  name: '${deployment().name}-pim-st-blob-${index}'
  scope: subscription(subscriptionId)
  params: {
    roleDefinitionId: roleMap['Storage Blob Data Owner'].id
    principalId: owner
  }
}]

// Deploy subscription owners default User Access Administrator PIM assignments in all environments except production.
module pimAssignmentUserAccessAdministrator 'modules/pimSub/pimSub.bicep' = [for (owner, index) in subscriptionOwners: if(environment != 'p'){
  name: '${deployment().name}-pim-ua-admin-${index}'
  scope: subscription(subscriptionId)
  params: {
    roleDefinitionId: roleMap['User Access Administrator'].id
    principalId: owner
  }
}]

// Deploy additional PIM role assignments
module pimAssignmentAdditional 'modules/pimSub/pimSub.bicep' = [for (assignment, index) in pimAdditionalSubscriptionRoleAssignments: {
  name: '${deployment().name}-pim-addt-${index}'
  scope: subscription(subscriptionId)
  params: {
    roleDefinitionId: roleMap[assignment.definition].id
    principalId: assignment.principalId
  }
}]

////////////////////////////////////////
//                                    //
//        Child DNS Zone setup        //
//                                    //
////////////////////////////////////////

// Deploy DNS zone resource group
module childDnsResourceGroup 'modules/resourceGroup/resourceGroup.bicep' = if (deployDnsZone) {
  name:  '${deployment().name}-child-dns-zone-rg'
  scope: subscription(subscriptionId)
  params: {
    resourceGroupName: dnsResourceGroupName
    location: location
  }
}

// Deploy Child DNS zone
module childDnsZone 'modules/dns/dnsZones.bicep' = if (deployDnsZone) {
  name:  '${deployment().name}-child-dns-zone'
  scope: resourceGroup(subscriptionId, dnsResourceGroupName)
  dependsOn: [childDnsResourceGroup]
  params: {
    dnsZoneName: dnsZoneName
    parentDnsZoneName: parentDnsZoneName
    environment: environment
    zoneType: zoneType
    connectivitySubscriptionId: connectivitySubscriptionId
    connetivityDnsResourceGroupName: connetivityDnsResourceGroupName
  }
}

////////////////////////////////////////
//                                    //
//        Security Contacts           //
//                                    //
////////////////////////////////////////

// Deploy Security Contacts properties

module securityContacts 'modules/securityContacts/securityContacts.bicep' = {
  name: '${deployment().name}-sec-contacts'
  scope: subscription(subscriptionId)
  params: {
    emails: securityContactEmail
    minimalSeverity: securityContactAlertMinimalSeverity
    notificationsByRole: securityContactNotificationsByRole
    securityContactAlertState: securityContactAlertState
  }
}
