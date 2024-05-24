<#
# .SYNOPSIS
#    Deletes all resources in the expired sandbox subscriptions and deactivate the subscription
#    This script is intended to be used in a scheduled task.
#>

param(
  [Parameter()]
  [String]$BicepOutputsArtifactPath = "$($env:BICEP_OUTPUTS_ARTIFACT_PATH)"
)

$ErrorActionPreference = 'Stop'

$currentDate = Get-Date -Format "yyyy-MM-dd"
$expiredSandboxSubscriptions = @()
$SandboxManagementGroupName = 'mg-example-sandbox'

Write-Verbose "Getting all subscriptions under Sandbox Managemeng Group ..."
$sandboxSubscriptions = Get-AzManagementGroupSubscription -GroupName $SandboxManagementGroupName

Write-Verbose "Removing all Azure Resources, Resource Groups and Deployments from Sandbox Subscriptions which tag ExpirationDate is expired"

foreach ($subscription in $sandboxSubscriptions) {
    $subscriptionDisplayName = $subscription.DisplayName

    # Define the regex pattern to match the subscription ID
    $pattern = "\w{8}-\w{4}-\w{4}-\w{4}-\w{12}"

    # Use the regex match operator to extract the GUID
    $subscriptionId = [Regex]::Matches($subscription.Id, $pattern).Value

    Write-Verbose "Set context to Subscription: $subscriptionDisplayName"
    Set-AzContext -Subscription $subscriptionId | Out-Null

    # Verify that the context subscription matches the subscription id
    $contextSubscriptionId = (Get-AzContext).Subscription.Id
    if ($subscriptionId -ne $contextSubscriptionId) {
        Write-Error "Failed to switch from current subscription id $contextSubscriptionId to sandbox subscription $subscriptionId ($subscriptionDisplayName)"
    }

    # Verify that the subscription environment tag is Sandbox
    $environment = (Get-AzTag  -Name "Environment").Values.Name
    if ($environment -ne "Sandbox") {
        Write-Error "Stopping pipeline. The subscription environment tag is not Sandbox in the $subscriptionDisplayName $subscriptionId"
    }

    # Get ExpirationDate tag for the subscription
    try {
        $expirationDate = (Get-AzTag  -Name "ExpirationDate").Values.Name
    }
    catch {
        Write-Error "ExpirationDate tag not found for subscription $subscriptionDisplayName $subscriptionId`n Error: $($_.Exception.Message)"
    }

    if($currentDate -gt $expirationDate) {
        Write-Verbose "Subscription $subscriptionDisplayName expired $expirationDate"
        $expiredSandboxSubscriptions += "$subscriptionDisplayName - $subscriptionId"

        # Get all Resource Groups in the sandbox subscription
        $resources = Get-AzResourceGroup

        $resources | ForEach-Object -Parallel {
            Write-Verbose "Deleting $($_.ResourceGroupName) ..."
            try {
                Remove-AzResourceGroup -Name $_.ResourceGroupName -Force | Out-Null
            }
            catch {
                Write-Error "Error deleting $($_.ResourceGroupName)`n Error: $($_.Exception.Message)"
            }
        }

        try {
            # Disable subscription
            Disable-AzSubscription -Id $subscriptionId -Confirm:$false
            Write-Verbose "Subscription $subscriptionDisplayName is now disabled"
        }
        catch {
            Write-Error "Error disabling the subscription $subscriptionDisplayName $subscriptionId`n Error: $($_.Exception.Message)"
        }
    }
    else {
        Write-Verbose "Subscription $subscriptionDisplayName has $expirationDate as expiration date"
    }
}

###
### Logic for creating artifact
###

# Get the artifact directory path.
$artifactPathDirs = Split-Path $BicepOutputsArtifactPath

# Create the directory if it doesn't exists.
if (!(Test-Path $artifactPathDirs)) {
    Write-Verbose "Directory $artifactPathDirs does not exists. Creating. . . "
    New-Item -ItemType Directory -Path $artifactPathDirs
}

# Write the artifact to directory.
Write-Verbose "Write artifact to $BicepArtifactOutputPath"
$expiredSandboxSubscriptions | ConvertTo-Json | Out-File -FilePath $BicepOutputsArtifactPath

# Print the result
Get-Content $BicepOutputsArtifactPath