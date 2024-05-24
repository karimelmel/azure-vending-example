param(
  [Parameter()]
  [String]$Location = "$($env:LOCATION)",

  [Parameter()]
  [String]$TopLevelMGPrefix = "$($env:TOP_LEVEL_MG_PREFIX)",

  [Parameter()]
  [String]$BicepOutputsArtifactPath = "$($env:BICEP_OUTPUTS_ARTIFACT_PATH)",

  [Parameter(
    Mandatory = $true,
    HelpMessage = "The full path to the landing zone file to deploy. If not specified, all landing zones will be deployed. Example: landing-zones/100-landing-zone/100-landing-zone.bicepparam or landing-zones/100-landing-zone"
   )]
  [String]$LandingZoneFile
)

$ErrorActionPreference = "Stop"

# Get all landing zones from the directory.
$files = Get-ChildItem -LiteralPath $LandingZoneFile

Write-Verbose "Found $($files.Count) bicep files"
Write-Verbose "Starting a job for each file..."
foreach($file in $files) {
    $fileName = $file.Name.Replace(".bicepparam", "")
    # We want to limit the deployment name.
    $azureDeploymentNamePrefix = (-join $fileName[0..13])
    # Set job name equal to file name.
    $jobName = $fileName
    # The file that will be deployed.
    $templateParameterFile = $file.FullName

    # Set deployment parameters
    $DeploymentName = "$azureDeploymentNamePrefix-{0}" -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
    $Location = $Location
    $ManagementGroupId = $TopLevelMGPrefix
    $TemplateParameterFile = $templateParameterFile

    # Start the deployment job
    Write-Verbose "Starting job [$jobName]"
    $job = Start-Job -Name $jobName -ScriptBlock {
        Write-Verbose "Starting deployment $using:DeploymentName"
        New-AzManagementGroupDeployment `
            -Name $using:DeploymentName `
            -Location $using:Location `
            -ManagementGroupId $using:ManagementGroupId `
            -TemplateParameterFile $using:TemplateParameterFile
    }
}

# Wait for all jobs to complete
Write-Verbose "***************************************************************************"
Write-Verbose "All jobs started. Waiting for jobs to complete for max 20 minutes..."
Write-Verbose "***************************************************************************"
$allJobs = Get-Job | Wait-Job -Timeout 1200

# Display job output
if ($null -eq $allJobs) {
    Get-Job
    Write-Error "Timed out waiting for jobs to complete"
}

# This will be set to true if one or more jobs failed.
$jobFailed = $false
# This variable will contain all deployments outputs
$allJobResults = @()

Write-Verbose "Jobs completed"
Write-Verbose "Displaying job output..."
foreach($job in $allJobs) {
    $jobName = $job.Name
    Write-Verbose "  "
    Write-Verbose "###############################################"
    Write-Verbose "###############################################"
    Write-Verbose "Job [$jobName] output:"
    Write-Verbose "###############################################"
    Write-Verbose "###############################################"
    Write-Verbose "  "
    try {
        $jobResult = Receive-Job -Name $jobName
        # Add the deployment output to a variable for use in artifact.
        $allJobResults += $jobResult
        # Print the result of the job to the console.
        $jobResult
    }
    catch {
        Write-Verbose "Job [$jobName] failed"
        $_.Exception.Message
        $jobFailed = $true
    }
}

# Cleanup jobs
Get-Job | Remove-Job

# The script should fail is one more more of the jobs failed.
if ($jobFailed) {
    Write-Error "Some jobs did not complete successfully. Please check the logs for more information."
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

# Get all deployment outputs. This will be used to create the artifact.
# The deployment outputs from the jobs are not correctly formatted So we need to run get-azdeployment.
$deploymentOutputs = @()
foreach($jobResult in $allJobResults) {
    $deploymentOutputs += Get-AzManagementGroupDeployment -Verbose -ManagementGroupId $TopLevelMGPrefix -Name $jobResult.DeploymentName | Select-Object -ExpandProperty Outputs
}

# Write the artifact to directory.
Write-Verbose "Write artifact to $BicepArtifactOutputPath"
$deploymentOutputs | ConvertTo-Json | Out-File -FilePath $BicepOutputsArtifactPath

# Print the result
Get-Content $BicepOutputsArtifactPath
