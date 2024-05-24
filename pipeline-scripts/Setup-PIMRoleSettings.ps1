<#
.SYNOPSIS
    Configures PIM role settings for a role to an array of subscriptions.

.DESCRIPTION
    Configures all PIM resources role settings for an array of subscriptions using a role settings policy as input.
    The current role settings applied to the subscription can be found using:

     # Get the details for your role manageemnt policy
     $subscriptionId = "00000000-0000-0000-0000-000000000000"
     $role = Get-AzRoleDefinition -Name "Owner"

     $pimResourceRoleRequest = @{
     	headers = $headers
     	uri     = "https://management.azure.com/subscriptions/$subscriptionId/providers/Microsoft.Authorization/roleManagementPolicies?api-version=2020-10-01&" + '$' + "filter=roleDefinitionId+eq+'subscriptions/$subscriptionId/providers/Microsoft.Authorization/roleDefinitions/$($role.id)'"
     	method  = "GET"
     }
     $pimResourceRoleRequestResults = (invoke-RestMethod @pimResourceRoleRequest).value

     # export the results to file for comparing. This step is only needed for tuning the settings
     $pimResourceRoleRequestResults | ConvertTo-Json -Depth 100 | Out-File -FilePath ".\settings.json"

.PARAMETER SubscriptionIds
    Array of subscription IDs the role settings will be applied.

.PARAMETER RoleId
    The ID of the Azure RBAC role that will be configured with a pim policy.

.PARAMETER RoleSettingsPath
    Path to a JSON file containing the role settings that will be applied to the role.

.PARAMETER RetryCount
    The number of times the script will retry the API request if it fails. Default is 3.

.PARAMETER RetryDelayInSeconds
    The number of seconds the script will wait before retrying the API request. Default is 5.
#>

param(
  [Parameter(Mandatory = $true)]
  [array]$SubscriptionIds,

  [Parameter(Mandatory = $true)]
  [string]$RoleId,

  [Parameter(Mandatory = $true)]
  [string]$RoleSettingsPath,

  [Parameter(Mandatory = $false)]
  [int]$RetryCount = 3,

  [Parameter(Mandatory = $false)]
  [int]$RetryDelayInSeconds = 5
)

# We want to stop if the fails
$errorActionPreference = 'Stop'

# Function to get access token
function Get-AzResourceManagerAccessToken {
    $context = Get-AzContext
    $resourceProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
    $client = New-Object Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient($resourceProfile)

    $token = $($client.AcquireAccessToken(($context).Tenant.TenantId).AccessToken)

    return $token
}

# Use powershell to get an accestoken based on the currently signed in account/service principal
$headers = @{
    Authorization = "Bearer $(Get-AzResourceManagerAccessToken)"
}

# Load the role setting
$bodySettingsJSON = Get-Content $RoleSettingsPath

# Loop through all Landing Zones created by Landing Zones Deployment step
foreach($subscriptionId in $SubscriptionIds) {
        Write-Verbose "Updating $RoleId for subscription: $subscriptionId"
        # Prepare the Request content with the body settings
        $pimResourceRoleUpdateRequest = @{
            headers     = $headers
            uri         = "https://management.azure.com/subscriptions/$subscriptionId/providers/Microsoft.Authorization/roleManagementPolicies/$($RoleId)?api-version=2020-10-01"
            method      = "PATCH"
            body        = $bodySettingsJSON
            ContentType = 'application/json'
        }

        Write-Verbose "Updating role settings for: $($pimResourceRoleUpdateRequest.uri) "

        # Use API request to update PIM Role Settings
        # Because the API is not always reliable we will retry the request a few times.
        for($i = 1; $i -le $RetryCount; $i++) {
            try {
                Invoke-RestMethod @pimResourceRoleUpdateRequest
            }
            catch {
                Write-Warning "Failed to update role settings for: $($pimResourceRoleUpdateRequest.uri) "
                Write-Warning "Attempt $i of $RetryCount"
                Start-Sleep -Seconds $RetryDelayInSeconds
            }
        }
}
