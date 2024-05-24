targetScope = 'managementGroup'

@allowed([
  'corp'
  'online'
  'connectivity'
  'identity'
  'security'
  'management'
  'sandbox'
])
@sys.description('The type of subscription to deploy.')
param archetype string

@allowed([
  'group'
  'tcs'
  'trm'
  'tf'
  'tsd'
])
@sys.description('The name of the business unit. Used for naming resources. See https://github.com/EXAMPLE-GitHub/az-platform/blob/main/docs/decisions/0002-azure-naming-convention.md#use-the-following-business-units-for-subscriptions')
param businessUnit string

@sys.description('The purpose of the subscription. Used for naming resources.')
param subscriptionPurpose string

@allowed([
  'd'
  'p'
  'q'
  't'
  'sandbox'
])
@description('Specifies resource environment')
param environment string

@sys.description('Short name of the location the resources will be deployed to.')
@allowed([
  'we'
  'eus'
  'ae'
  'glb'
])
param locationShortName string = 'we'

@description('The prefix of the top level management group. Used to set name of other management groups.')
param topLevelManagementGroupPrefix string

@sys.description('The Billing Scope for the new Subscription alias.')
param subscriptionBillingScope string = 'providers/Microsoft.Billing/billingAccounts/62738888/enrollmentAccounts/355243'

type tagCriticalityType = 'Unsupported' | 'Low' | 'Medium' | 'High' | 'Unit-critical' | 'Mission-critical'
type tagBusinessType = 'Example 1' | 'Example 2' | 'Example 3'
type tagEnvironment = 'Development' | 'Test' | 'QA' | 'Production' | 'Sandbox'

type tagsType = {
  Owner: string
  Criticality: tagCriticalityType
  Business: tagBusinessType
  Environment: tagEnvironment
  ExpirationDate: string?
}

@metadata({
  example: {
    Owner: 'string'
    Criticality: 'tagCriticalityType'
    Business: 'tagBusinessType'
    Environment: 'tagEnvironment'
  }
})
@sys.description('An object of Tag key & value pairs to be appended to a Subscription and other objects.')
param tags tagsType

@sys.description('The Virtual WAN Virtual Hub Resource ID that the Virtual Network will be peered to.')
param hubNetworkResourceId string = '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-connectivity/providers/Microsoft.Network/virtualHubs/vhub-example-we'

@sys.description('Only relevant for corp subscriptions. This parameter must first be set to false to deploy a VNET then to true again after the VNET is deployed. The pipeline will fail if the VNET already exists with subnets. See: https://github.com/Azure/azure-quickstart-templates/issues/2786.')
param isVnetDeployed bool = true

@sys.description('Location the resources will be deployed to.')
param location string = 'westeurope'

@metadata({
  example: [
    '10.0.0.0/16'
  ]
})
@sys.description('The address space of the Virtual Network that will be created by this module, supplied as multiple CIDR blocks in an array, e.g. `["10.0.0.0/16","172.16.0.0/12"]`')
param virtualNetworkAddressSpace array = []

@sys.description('The custom DNS servers to use on the Virtual Network. In the hub extension deployment, this parameter refers to Firewall DNS.')
param virtualNetworkDnsServers array = ['10.10.0.132']

@sys.description('Object ID of the service principal that will deploy to the subscription.')
param servicePrincipalObjectId string = ''

@minLength(3)
@maxLength(47)
@sys.description('The name of the Subscription Alias that will be created. This also sets the display name of the subscription.')
param subscriptionAliasName string = '${businessUnit}-${subscriptionPurpose}-${environment}-${locationShortName}'

@sys.description('The name of the Subscription Display Name. This also sets the display name of the subscription.')
param subscriptionDisplayName string = '${businessUnit}-${subscriptionPurpose}-${environment}-${locationShortName}'

@sys.description('The list of cloud admin accounts that will be owners for the subscriptions. These will be granted Reader, (pim) Subscription Owner and (pim) Key Vault Secrets Officer.')
@metadata({
  example: [
    'xxxx.yyyy@zzzz.com'
    'xxxx.yyyy@zzzz.com'
    'xxxx.yyyy@zzzz.com'
  ]
})
param subscriptionOwners array = []

@metadata({
  example: [
    {
      principalId: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      definition: 'Contributor'
      relativeScope: ''
    }
  ]
})
@sys.description('Supply an array of objects containing the details of the role assignments to create.')
param subscriptionRoleAssignments array = []

@sys.description('The total amount of cost or usage to track with the budget in NOK per month.')
param budgetAmount int = 5000

@sys.description('The list of email addresses to send the budget notification to when the threshold is exceeded.')
param budgetContactEmails array = []

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

@sys.description('Flag to enable DNS setup')
param deployDnsZone bool = false

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

@sys.description('The existing connectivity subscription ID')
param managementSubscriptionId string = '00000000-0000-0000-0000-000000000000'

@sys.description('The existing bicep modules resource group name.')
param bicepModulesResourceGroup string = 'rg-examplebicepmodules'

@sys.description ('The resource group name for the hub network. Only relevant for corp subscriptions.')
param virtualNetworkResourceGroupName string = 'rg-network-${subscriptionPurpose}-${environment}-${locationShortName}'

@sys.description('Email address which will get notifications from Microsoft Defender for Cloud by the configurations defined in this security contact.	')
param securityContactEmail string = 'security@example.com'

@allowed([
  'AccountAdmin'
  'Contributor'
  'Owner'
  'ServiceAdmin'])
@sys.description('Defines whether to send email notifications from Microsoft Defender for Cloud to persons with specific RBAC roles on the subscription.')
param securityContactNotificationsByRole array = [
  'Contributor'
  'Owner'
]

@allowed([
  'On'
  'Off'
])
@sys.description('Defines if email notifications will be sent about new security alerts')
param securityContactAlertState string = 'On'

@allowed([
  'Low'
  'Medium'
  'High'
])
@sys.description('Defines the minimal alert severity which will be sent as email notifications.')
param securityContactAlertMinimalSeverity string = 'High'

// We want to assign permanent reader for the subscription owners.
var subscriptionRoleAssignmentsDefault = [
  for (subscriptionOwner, i) in subscriptionOwners : {
    principalId: subscriptionOwner
    definition: 'Reader'
    relativeScope: ''
  }
]

// We want to assign the owner role for the service principal.
var servicePrincipalRoleAssignments = empty(servicePrincipalObjectId) ? [] : [
  {
    principalId: servicePrincipalObjectId
    definition: 'Owner'
    relativeScope: ''
  }
]

// Union the default, custom, and service principal role assignment.
var combinedRoleAssignments = union(subscriptionRoleAssignmentsDefault, subscriptionRoleAssignments, servicePrincipalRoleAssignments)

// Set properties for the different archetypes.
var archetypeProperties = {
  corp: {
    subscriptionManagementGroupId: '${topLevelManagementGroupPrefix}-landingzones-corp'
    hubNetworkResourceId: hubNetworkResourceId
    virtualNetworkEnabled: !isVnetDeployed // Deploy the VNET if it's not already deployed.
    virtualNetworkResourceGroupName: virtualNetworkResourceGroupName
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkLocation: location
    virtualNetworkName: 'vnet-${subscriptionPurpose}-${environment}-${locationShortName}'
    virtualNetworkAddressSpace: virtualNetworkAddressSpace
    virtualNetworkPeeringEnabled: true
    virtualNetworkDnsServers: virtualNetworkDnsServers
  }
  online: {
   subscriptionManagementGroupId: '${topLevelManagementGroupPrefix}-landingzones-online'
  }
  sandbox: {
   subscriptionManagementGroupId: '${topLevelManagementGroupPrefix}-sandbox'
  }
  connectivity: {
   subscriptionManagementGroupId: '${topLevelManagementGroupPrefix}-platform-connectivity'
  }
  management: {
   subscriptionManagementGroupId: '${topLevelManagementGroupPrefix}-platform-management'
  }
  identity: {
   subscriptionManagementGroupId: '${topLevelManagementGroupPrefix}-platform-identity'
  }
  security: {
   subscriptionManagementGroupId: '${topLevelManagementGroupPrefix}-platform-security' 
  }
}

// Deploy the subscription.
module landingzone 'br/public:lz/sub-vending:1.4.1' = {
  name: '${deployment().name}-lz'
  params: {
    subscriptionAliasEnabled: true
    subscriptionAliasName: subscriptionAliasName
    subscriptionDisplayName: subscriptionDisplayName
    subscriptionBillingScope: subscriptionBillingScope
    subscriptionWorkload: 'Production'
    roleAssignmentEnabled: true
    roleAssignments: combinedRoleAssignments
    subscriptionTags: tags
    disableTelemetry: true
    subscriptionManagementGroupId: archetypeProperties[archetype].subscriptionManagementGroupId
    hubNetworkResourceId: contains(archetypeProperties[archetype], 'hubNetworkResourceId') ? archetypeProperties[archetype].hubNetworkResourceId : ''
    virtualNetworkEnabled: contains(archetypeProperties[archetype], 'virtualNetworkEnabled') ? archetypeProperties[archetype].virtualNetworkEnabled : false
    virtualNetworkResourceGroupName: contains(archetypeProperties[archetype], 'virtualNetworkResourceGroupName') ? archetypeProperties[archetype].virtualNetworkResourceGroupName : ''
    virtualNetworkResourceGroupLockEnabled: contains(archetypeProperties[archetype], 'virtualNetworkResourceGroupLockEnabled') ? archetypeProperties[archetype].virtualNetworkResourceGroupLockEnabled : true
    virtualNetworkLocation: contains(archetypeProperties[archetype], 'virtualNetworkLocation') ? archetypeProperties[archetype].virtualNetworkLocation : location
    virtualNetworkName: contains(archetypeProperties[archetype], 'virtualNetworkName') ? archetypeProperties[archetype].virtualNetworkName : ''
    virtualNetworkAddressSpace: contains(archetypeProperties[archetype], 'virtualNetworkAddressSpace') ? archetypeProperties[archetype].virtualNetworkAddressSpace : []
    virtualNetworkPeeringEnabled: contains(archetypeProperties[archetype], 'virtualNetworkPeeringEnabled') ? archetypeProperties[archetype].virtualNetworkPeeringEnabled : false
    virtualNetworkDnsServers: contains(archetypeProperties[archetype], 'virtualNetworkDnsServers') ? archetypeProperties[archetype].virtualNetworkDnsServers : []
  }
}

// Assign AcrPull to the subscription service principal if provided.
module rgRoleAssignment 'modules/roleAssignment/resourceGroupRoleAssignment.bicep' = if (!empty(servicePrincipalObjectId)) {
  name: '${deployment().name}-acr'
  scope: resourceGroup(managementSubscriptionId, bicepModulesResourceGroup)
  params: {
    principalId: servicePrincipalObjectId
    roleDefinitionId: '7f951dda-4ed3-4680-a7ca-43fe172d538d'
  }
}

// The subscription ID value can't be calculated so we need to pass it in for the other deployments.
module customSubscriptionDeployments 'subscriptionWrapper.bicep' = {
  name: '${deployment().name}-wrapper'
  params: {
    budgetAmount: budgetAmount
    budgetContactEmails: budgetContactEmails
    budgetName: 'budget-monthly-${businessUnit}-${subscriptionPurpose}-${environment}-${locationShortName}'
    connectivitySubscriptionId: connectivitySubscriptionId
    connetivityDnsResourceGroupName: connetivityDnsResourceGroupName
    deployDnsZone: deployDnsZone
    dnsResourceGroupName: 'rg-dns-${subscriptionPurpose}-${environment}-${locationShortName}'
    dnsZoneName: subscriptionPurpose
    environment: environment
    location: location
    parentDnsZoneName: '${environment}-lz.az.example.com'
    pimSubscriptionRoleAssignments: pimSubscriptionRoleAssignments
    subscriptionId: landingzone.outputs.subscriptionId
    subscriptionOwners: subscriptionOwners
    zoneType: zoneType
    securityContactEmail: securityContactEmail
    securityContactNotificationsByRole: securityContactNotificationsByRole
    securityContactAlertState: securityContactAlertState
    securityContactAlertMinimalSeverity: securityContactAlertMinimalSeverity
  }
}

output tenant_id string = tenant().tenantId
output subscription_id string = landingzone.outputs.subscriptionId
