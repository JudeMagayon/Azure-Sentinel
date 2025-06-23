# ===============================
# Microsoft Sentinel Free Log Ingestion - Create/Destroy Script
# ===============================

# Prompt for mode
$action = Read-Host "Type 'create' to set up or 'destroy' to remove the connectors"

# Prompt for workspace and resource group
$resourceGroup = Read-Host "Enter your Resource Group name"
$workspaceName = Read-Host "Enter your Sentinel Workspace name"

# Display what will be done
Write-Host "`n===================================="
Write-Host "The following FREE log types will be processed in '$action' mode:"
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
Write-Host "10. SecurityAlert (Other sources)"
Write-Host "11. SecurityIncident (XDR)"
Write-Host "====================================`n"  

Write-Host "SentinelHealth — is automatically ingested, no connector is needed."
Write-Host "SecurityAlert (IPC) (Entra ID Protection) — is part of Microsoft 365 Defender and logs to SecurityAlert, but there's no direct connector."
Write-Host "It comes in if: "
Write-Host "- Entra ID Protection is licensed (P2)"
Wrrite-Host "- Alert policies are configured"
Write-Host "SecurityAlert (general) — is a data type, not a connector kind. It’s populated by the other connectors (Defender for Endpoint, Cloud Apps, Identity, etc.)."

# Gather environment info
$subscriptionId = az account show --query id -o tsv
$tenantId = az account show --query tenantId -o tsv
$workspaceId = az monitor log-analytics workspace show --resource-group $resourceGroup --workspace-name $workspaceName --query id -o tsv

# Track results
$results = @()
$success = $true

# List of connectors
$connectors = @(
    @{ kind = "Office365"; name = "office365-connector"; props = "{ `"tenantId`": `"$tenantId`" }" },
    @{ kind = "MicrosoftDefenderAdvancedThreatProtection"; name = "mdatp-connector"; props = "{ `"tenantId`": `"$tenantId`" }" },
    @{ kind = "AzureAdvancedThreatProtection"; name = "aatp-connector"; props = "{ `"tenantId`": `"$tenantId`" }" },
    @{ kind = "MicrosoftCloudAppSecurity"; name = "mcas-connector"; props = "{ `"tenantId`": `"$tenantId`" }" },
    @{ kind = "AzureSecurityCenter"; name = "asc-connector"; props = "{ `"tenantId`": `"$tenantId`" }" },
    @{ kind = "IoT"; name = "iot-connector"; props = "{}" },
    @{ kind = "MicrosoftDefenderIncident"; name = "xdr-incident-connector"; props = "{ `"tenantId`": `"$tenantId`" }" }
)

$diagName = "activity-logs-to-sentinel"

if ($action -eq "create") {

    # Create Diagnostic Settings
    try {
        $diagExists = az monitor diagnostic-settings list `
            --resource "/subscriptions/$subscriptionId" `
            --query "[?name=='$diagName']" -o json | ConvertFrom-Json

        if ($diagExists.Count -gt 0) {
            Write-Host "AzureActivity diagnostic already exists"
            $results += [pscustomobject]@{ Connector="AzureActivity"; Status="Already exists" }
        }
        else {
            az monitor diagnostic-settings create `
                --name $diagName `
                --resource "/subscriptions/$subscriptionId" `
                --workspace $workspaceId `
                --logs '[{"category":"Administrative","enabled":true},
                         {"category":"Policy","enabled":true},
                         {"category":"Security","enabled":true},
                         {"category":"ServiceHealth","enabled":true},
                         {"category":"Alert","enabled":true},
                         {"category":"Recommendation","enabled":true},
                         {"category":"Autoscale","enabled":true},
                         {"category":"ResourceHealth","enabled":true}]' | Out-Null
            Write-Host "AzureActivity diagnostic created"
            $results += [pscustomobject]@{ Connector="AzureActivity"; Status="Created" }
        }
    }
    catch {
        $success = $false
        $results += [pscustomobject]@{ Connector="AzureActivity"; Status="Failed: $_" }
    }

    # Create each connector
    foreach ($conn in $connectors) {
        try {
            $existing = az sentinel data-connector list `
                --resource-group $resourceGroup `
                --workspace-name $workspaceName `
                --query "[?kind=='$($conn.kind)']" -o json | ConvertFrom-Json

            if ($existing.Count -gt 0) {
                Write-Host "$($conn.kind) already exists"
                $results += [pscustomobject]@{ Connector=$conn.kind; Status="Already exists" }
            }
            else {
                $connectorId = [guid]::NewGuid()
                az sentinel data-connector create `
                    --name $conn.name `
                    --resource-group $resourceGroup `
                    --workspace-name $workspaceName `
                    --connector-id $connectorId `
                    --kind $conn.kind `
                    --properties $conn.props | Out-Null
                Write-Host "$($conn.kind) created"
                $results += [pscustomobject]@{ Connector=$conn.kind; Status="Created" }
            }
        }
        catch {
            $success = $false
            $results += [pscustomobject]@{ Connector=$conn.kind; Status="Failed: $_" }
        }
    }

} elseif ($action -eq "destroy") {

    try {
        $diagExists = az monitor diagnostic-settings list `
            --resource "/subscriptions/$subscriptionId" `
            --query "[?name=='$diagName']" -o json | ConvertFrom-Json

        if ($diagExists.Count -gt 0) {
            az monitor diagnostic-settings delete `
                --resource "/subscriptions/$subscriptionId" `
                --name $diagName | Out-Null
            Write-Host "AzureActivity diagnostic removed"
            $results += [pscustomobject]@{ Connector="AzureActivity"; Status="Removed" }
        }
        else {
            $results += [pscustomobject]@{ Connector="AzureActivity"; Status="Not found" }
        }
    }
    catch {
        $success = $false
        $results += [pscustomobject]@{ Connector="AzureActivity"; Status="Failed to delete: $_" }
    }

    $existingConns = az sentinel data-connector list `
        --resource-group $resourceGroup `
        --workspace-name $workspaceName -o json | ConvertFrom-Json

    foreach ($conn in $connectors) {
        try {
            $target = $existingConns | Where-Object { $_.kind -eq $conn.kind }
            if ($null -ne $target) {
                az sentinel data-connector delete `
                    --name $target.name `
                    --resource-group $resourceGroup `
                    --workspace-name $workspaceName | Out-Null
                Write-Host "$($conn.kind) removed"
                $results += [pscustomobject]@{ Connector=$conn.kind; Status="Removed" }
            }
            else {
                $results += [pscustomobject]@{ Connector=$conn.kind; Status="Not found" }
            }
        }
        catch {
            $success = $false
            $results += [pscustomobject]@{ Connector=$conn.kind; Status="Failed to delete: $_" }
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
    Write-Host "`n SUCCESS: All '$action' operations completed successfully!" -ForegroundColor Green
} else {
    Write-Host "`n Completed with some errors. Check the summary above." -ForegroundColor Yellow
}
