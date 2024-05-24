<#
# .SYNOPSIS
#    Deletes all deployments older than a specified number of days.
#    This script is intended to be used in a scheduled task.
#    The script will delete deployments in the management group specified by the TOP_LEVEL_MG_PREFIX environment variable.
#>

param(
    [Parameter()]
    [String]$TargetManagementGroup = "$($env:TOP_LEVEL_MG_PREFIX)",

    [Parameter(Mandatory = $true)]
    [int]$NumberOfDaysAgo
)

# Get the current deployments in the management group
Write-Verbose "Getting deployments in management group: $TargetManagementGroup"
$deployments = Get-AzManagementGroupDeployment `
  -ManagementGroupId $TargetManagementGroup | Where-Object -Property Timestamp -LT -Value ((Get-Date).AddDays(-$NumberOfDaysAgo))

Write-Verbose "Found $($deployments.Count) deployments older than $NumberOfDaysAgo days"

# Sort the deployments by timestamp so we delete the oldest first.
$deployments = $deployments | Sort-Object -Property Timestamp

# To avoid timeout from GitHub workflow we only select the first 100 objects.
Write-Verbose "Deleting the first 100 deployments"
$deployments = $deployments | Select-Object -First 100
$index = 1

foreach ($deployment in $deployments) {

    try {
        Write-Verbose "Deleting deployment [$index/$($deployments.count)]: $($deployment.DeploymentName)"
        Remove-AzManagementGroupDeployment -ManagementGroupId $TargetManagementGroup -Name $deployment.DeploymentName
    }catch{
        # Sometimes the deployment is already deleted, so we ignore the error.
        Write-Warning "Failed to delete deployment: $($deployment.DeploymentName)"
        Write-Warning $_.Exception.Message
    }

    $index += 1
}
