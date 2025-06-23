# ===============================
# Microsoft Sentinel Free Log Ingestion - Create/Destroy Script with Selection
# ===============================

# Prompt for mode
$action = Read-Host "Type 'create' to set up or 'destroy' to remove the connectors"

# Prompt for workspace and resource group
$resourceGroup = Read-Host "Enter your Resource Group name"
$workspaceName = Read-Host "Enter your Sentinel Workspace name"

# Display available options
Write-Host "`n===================================="
Write-Host "Select which FREE log types to process:`nType numbers separated by commas (e.g. 1,3,5) or type 'all' to process everything"
Write-Host "===================================="
Write-Host "1. AzureActivity (Platform Logs)"
Write-Host "2. SentinelHealth (Automatic)"
Write-Host "3. OfficeActivity (Exchange, SharePoint, Teams)"
Write-Host "4. SecurityAlert (Entra ID Protection - IPC)"
Write-Host "5. SecurityAlert (Defender for Endpoint - MDATP)"
Write-Host "6. SecurityAlert (Defender for Identity - AATP)"
Write-Host "7. SecurityAlert (Defender for Cloud Apps - MCAS)"
Write-Host "8. SecurityAlert (Defender for Cloud)"
Write-Host "9. SecurityAlert (Defender for IoT)"
Write-Host "10. SecurityIncident (Microsoft Defender XDR)"
Write-Host "11. SecurityAlert (Microsoft Defender XDR)"
Write-Host "====================================`n"

Write-Host "SentinelHealth — is automatically ingested, no connector is needed."
Write-Host "SecurityAlert (IPC) — logs under 'SecurityAlert' if Entra ID Protection (P2) is licensed and configured."
Write-Host "SecurityAlert — is a data type, populated by other connectors like Defender for Cloud, IoT, Endpoint, etc."

# User selection
$selection = Read-Host "Your selection"

# Define connector index map
$indexMap = @{
    1 = "AzureActivity"
    3 = "Office365"
    5 = "MicrosoftDefenderAdvancedThreatProtection"
    6 = "AzureAdvancedThreatProtection"
    7 = "MicrosoftCloudAppSecurity"
    8 = "AzureSecurityCenter"
    9 = "IoT"
    10 = "MicrosoftDefenderIncident"
    11 = "MicrosoftDefenderIncident"
}

# Parse selection
$selectedKinds = @()
if ($selection -eq "all") {
    $selectedKinds = $indexMap.Values | Select-Object -Unique
} else {
    $indexes = $selection -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^\d+$' }
    foreach ($idx in $indexes) {
        if ($indexMap.ContainsKey([int]$idx)) {
            $selectedKinds += $indexMap[[int]$idx]
        }
    }
}

if ($selectedKinds.Count -eq 0) {
    Write-Host "No valid connectors selected. Exiting."
    return
}

# Gather environment info
$subscriptionId = az account show --query id -o tsv
$tenantId = az account show --query tenantId -o tsv
$workspaceId = az monitor log-analytics workspace show --resource-group $resourceGroup --workspace-name $workspaceName --query id -o tsv

# Track results
$results = @()
$success = $true

# Define full connector list
$connectors = @(
    @{ kind = "Office365"; name = "office365-connector"; props = "{ \"tenantId\": \"$tenantId\" }" },
    @{ kind = "MicrosoftDefenderAdvancedThreatProtection"; name = "mdatp-connector"; props = "{ \"tenantId\": \"$tenantId\" }" },
    @{ kind = "AzureAdvancedThreatProtection"; name = "aatp-connector"; props = "{ \"tenantId\": \"$tenantId\" }" },
    @{ kind = "MicrosoftCloudAppSecurity"; name = "mcas-connector"; props = "{ \"tenantId\": \"$tenantId\" }" },
    @{ kind = "AzureSecurityCenter"; name = "asc-connector"; props = "{ \"tenantId\": \"$tenantId\" }" },
    @{ kind = "IoT"; name = "iot-connector"; props = "{}" },
    @{ kind = "MicrosoftDefenderIncident"; name = "xdr-incident-connector"; props = "{ \"tenantId\": \"$tenantId\" }" }
)

$diagName = "activity-logs-to-sentinel"

if ($action -eq "create") {
    if ($selectedKinds -contains "AzureActivity") {
        try {
            $diagExists = az monitor diagnostic-settings list --resource "/subscriptions/$subscriptionId" --query "[?name=='$diagName']" -o json | ConvertFrom-Json
            if ($diagExists.Count -gt 0) {
                $results += [pscustomobject]@{ Connector="AzureActivity"; Status="Already exists" }
            } else {
                az monitor diagnostic-settings create --name $diagName --resource "/subscriptions/$subscriptionId" --workspace $workspaceId --logs '[{"category":"Administrative","enabled":true},{"category":"Policy","enabled":true},{"category":"Security","enabled":true},{"category":"ServiceHealth","enabled":true},{"category":"Alert","enabled":true},{"category":"Recommendation","enabled":true},{"category":"Autoscale","enabled":true},{"category":"ResourceHealth","enabled":true}]' | Out-Null
                $results += [pscustomobject]@{ Connector="AzureActivity"; Status="Created" }
            }
        } catch {
            $success = $false
            $results += [pscustomobject]@{ Connector="AzureActivity"; Status="Failed: $_" }
        }
    }

    foreach ($conn in $connectors) {
        if ($selectedKinds -contains $conn.kind) {
            try {
                $existing = az sentinel data-connector list --resource-group $resourceGroup --workspace-name $workspaceName --query "[?kind=='$($conn.kind)']" -o json | ConvertFrom-Json
                if ($existing.Count -gt 0) {
                    $results += [pscustomobject]@{ Connector=$conn.kind; Status="Already exists" }
                } else {
                    $connectorId = [guid]::NewGuid()
                    az sentinel data-connector create --name $conn.name --resource-group $resourceGroup --workspace-name $workspaceName --connector-id $connectorId --kind $conn.kind --properties $conn.props | Out-Null
                    $results += [pscustomobject]@{ Connector=$conn.kind; Status="Created" }
                }
            } catch {
                $success = $false
                $results += [pscustomobject]@{ Connector=$conn.kind; Status="Failed: $_" }
            }
        }
    }

} elseif ($action -eq "destroy") {
    if ($selectedKinds -contains "AzureActivity") {
        try {
            $diagExists = az monitor diagnostic-settings list --resource "/subscriptions/$subscriptionId" --query "[?name=='$diagName']" -o json | ConvertFrom-Json
            if ($diagExists.Count -gt 0) {
                az monitor diagnostic-settings delete --resource "/subscriptions/$subscriptionId" --name $diagName | Out-Null
                $results += [pscustomobject]@{ Connector="AzureActivity"; Status="Removed" }
            } else {
                $results += [pscustomobject]@{ Connector="AzureActivity"; Status="Not found" }
            }
        } catch {
            $success = $false
            $results += [pscustomobject]@{ Connector="AzureActivity"; Status="Failed to delete: $_" }
        }
    }

    $existingConns = az sentinel data-connector list --resource-group $resourceGroup --workspace-name $workspaceName -o json | ConvertFrom-Json
    foreach ($conn in $connectors) {
        if ($selectedKinds -contains $conn.kind) {
            try {
                $target = $existingConns | Where-Object { $_.kind -eq $conn.kind }
                if ($null -ne $target) {
                    az sentinel data-connector delete --name $target.name --resource-group $resourceGroup --workspace-name $workspaceName | Out-Null
                    $results += [pscustomobject]@{ Connector=$conn.kind; Status="Removed" }
                } else {
                    $results += [pscustomobject]@{ Connector=$conn.kind; Status="Not found" }
                }
            } catch {
                $success = $false
                $results += [pscustomobject]@{ Connector=$conn.kind; Status="Failed to delete: $_" }
            }
        }
    }

} else {
    Write-Host "❌ Invalid action. Please type 'create' or 'destroy'."
    return
}

# Output summary
Write-Host "`n======== Operation Summary ========"
$results | Format-Table -AutoSize

# Final success message
if ($success) {
    Write-Host "`n✅ SUCCESS: All '$action' operations completed successfully!" -ForegroundColor Green
} else {
    Write-Host "`n⚠️  Completed with some errors. Check the summary above." -ForegroundColor Yellow
}
