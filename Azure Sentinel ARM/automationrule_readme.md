![Secon-white-logo-green-1-768x149](https://github.com/user-attachments/assets/a66347b8-c453-4cac-b7f3-fe71a9c5d839)

# Secon Cyber | Microsoft Sentinel | Deployment Automation

This project automates the deployment and initial configuration of Microsoft Sentinel environments. It is ideal for **Proof of Concept (PoC)**, **customer onboarding**, or **MSSP-managed SOC** scenarios.

---

## What This Automation Does

- Creates a **Resource Group**
- Deploys a **Log Analytics Workspace**
- Installs **Microsoft Sentinel** on the workspace
- Configures:
  - **Log retention**
  - [**Daily cap**](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/daily-cap)
  - **Commitment tiers**
- Enables **UEBA** (User & Entity Behavior Analytics) with Azure AD and/or on-prem AD
- Enables **health diagnostics** for:
  - Analytics Rules
  - Data Connectors
  - Automation Rules
- Deploys **Content Hub solutions**
- Enables the following **Data Connectors**:
  - Azure Active Directory *(tenant-scope only)*
  - Azure AD Identity Protection
  - Azure Activity
  - Dynamics 365
  - Microsoft 365 Defender
  - Microsoft Defender for Cloud
  - Microsoft Insider Risk Management
  - Microsoft Power BI
  - Microsoft Project
  - Office 365
  - Threat Intelligence Platforms
- Deploys **Scheduled and Near-Real-Time analytics rules** from:
  - Enabled Content Hub solutions
  - Selected Data Connectors
- Includes Automation Rule to **auto-close noisy incidents** (e.g., MFA Deny)

⏱ **Estimated Time to Deploy**:
- With analytics rules: ~10 minutes  
- Without analytics rules: ~2 minutes

---

## Prerequisites

- An **Azure Subscription**
- **Microsoft Sentinel Contributor** role (minimum)
- Some data connectors require specific licenses (see table below)

---

## 🔧 Deployment Options

### Full Microsoft Sentinel Environment

Deploy a complete Microsoft Sentinel environment with all components:

| Deployment Scope       | Deploy | Required Permission |
|------------------------|--------|---------------------|
| **Subscription Scope** | [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FJudeMagayon%2FAzure-Sentinel%2F3e2ad3ef962b54caed5ad8cdc6c677819076ed93%2FAzure%2520Sentinel%2520V2%2Fazuredeploy.json/createUIDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2FJudeMagayon%2FAzure-Sentinel%2F3e2ad3ef962b54caed5ad8cdc6c677819076ed93%2FAzure%2520Sentinel%2520V2%2FcreateUiDefinition.json) | Microsoft Sentinel Contributor |

### Standalone Automation Rule

Deploy only the automation rule for auto-closing noisy incidents (ideal for existing Sentinel workspaces):

| Component | Deploy | Description |
|-----------|--------|-------------|
| **Automation Rule** | [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FJudeMagayon%2FAzure-Sentinel%2Fmain%2FAzure%2520Sentinel%2520V2%2Fautomationrule.json) | Auto-closes incidents containing "MFA Deny" in title |

#### Automation Rule Features
- **Trigger**: Activates when new incidents are created
- **Condition**: Targets incidents with "MFA Deny" in the title
- **Action**: Automatically closes incidents as "Benign Positive"
- **Benefit**: Reduces alert fatigue from common false positives

#### Automation Rule Parameters
| Parameter | Description | Default Value |
|-----------|-------------|---------------|
| `workspaceName` | Name of existing Sentinel workspace | *Required* |
| `location` | Azure region | `southeastasia` |
| `automationRuleName` | Name for the automation rule | `AutoCloseNoisyIncidents` |

---

## Manual Deployment

### Full Environment - Azure CLI
```bash
# Create resource group
az group create --name "rg-sentinel-poc" --location "southeastasia"

# Deploy full environment
az deployment group create \
  --resource-group "rg-sentinel-poc" \
  --template-file "Azure Sentinel V2/azuredeploy.json" \
  --parameters @"Azure Sentinel V2/azuredeploy.parameters.json"
```

### Automation Rule Only - Azure CLI
```bash
# Deploy automation rule to existing workspace
az deployment group create \
  --resource-group "your-existing-rg" \
  --template-file "Azure Sentinel V2/automationrule.json" \
  --parameters workspaceName="your-workspace-name"
```

### PowerShell Deployment
```powershell
# Full environment
New-AzResourceGroupDeployment `
  -ResourceGroupName "rg-sentinel-poc" `
  -TemplateFile "Azure Sentinel V2/azuredeploy.json" `
  -TemplateParameterFile "Azure Sentinel V2/azuredeploy.parameters.json"

# Automation rule only
New-AzResourceGroupDeployment `
  -ResourceGroupName "your-existing-rg" `
  -TemplateFile "Azure Sentinel V2/automationrule.json" `
  -workspaceName "your-workspace-name"
```

---

## Supported Data Connectors

| Data Connector                             | License            | Required Permissions            | Ingestion Cost |
|--------------------------------------------|--------------------|----------------------------------|----------------|
| Azure Active Directory *(tenant only)*     | Any AAD license    | Global Admin / Security Admin   | **Billed**     |
| Azure AD Identity Protection               | AAD Premium P2     | Global Admin / Security Admin   | **Free**       |
| Azure Activity                             | None               | Subscription Reader             | **Free**       |
| Dynamics 365                               | D365 License       | Global Admin / Security Admin   | **Billed**     |
| Microsoft 365 Defender                     | M365D License      | Global Admin / Security Admin   | **Free**       |
| Microsoft Defender for Cloud               | MDC License        | Security Reader                 | **Free**       |
| Insider Risk Management                    | IRM License        | Global Admin / Security Admin   | **Free**       |
| Microsoft Power BI                         | Power BI License   | Global Admin / Security Admin   | **Billed**     |
| Microsoft Project                          | Project License    | Global Admin / Security Admin   | **Billed**     |
| Office 365                                 | None               | Global Admin / Security Admin   | **Free**       |
| Threat Intelligence Platforms              | None               | Global Admin / Security Admin   | **Billed**     |

---

## 🎯 Use Cases

### Full Deployment
- **New Sentinel implementations**
- **PoC environments**
- **Customer onboarding**
- **MSSP managed SOC setup**

### Automation Rule Only
- **Existing Sentinel workspaces** with noise issues
- **Quick wins** for alert fatigue reduction
- **Incident management optimization**
- **Testing automated response workflows**

---

## ⚠️ Important Notes

### Security Considerations
- **Test first**: Deploy automation rules in non-production environments initially
- **Monitor closely**: Review auto-closed incidents to ensure no false positives
- **Customize conditions**: Adjust automation rule conditions based on your environment
- **Audit trail**: All automated actions are logged for compliance

### Cost Management
- Review data connector costs before enabling
- Configure daily caps to control ingestion costs
- Monitor workspace usage regularly
- Consider commitment tiers for predictable costs

---

## 🔧 Customization

### Modify Automation Rule Conditions

To customize what incidents get auto-closed, edit the automation rule template:

```json
"conditions": [
  {
    "property": "Incident.Title",
    "operator": "Contains",
    "value": "Your Custom Text"
  },
  {
    "property": "Incident.Severity",
    "operator": "Equals",
    "value": "Low"
  }
]
```

### Common Automation Rule Patterns

1. **MFA Denials**: `"Contains"` + `"MFA Deny"`
2. **Low Severity**: `"Equals"` + `"Low"`
3. **Specific Sources**: `"Contains"` + `"SourceSystem"`
4. **Time-based**: Add scheduling logic for business hours

---

## 📚 Additional Resources

- [Microsoft Sentinel Documentation](https://docs.microsoft.com/en-us/azure/sentinel/)
- [Automation Rules Guide](https://docs.microsoft.com/en-us/azure/sentinel/automate-incident-handling-with-automation-rules)
- [Content Hub Solutions](https://docs.microsoft.com/en-us/azure/sentinel/sentinel-solutions)
- [Data Connectors Reference](https://docs.microsoft.com/en-us/azure/sentinel/connect-data-sources)

---

## 🆘 Support

For issues and questions:
- Create an [issue](https://github.com/JudeMagayon/Azure-Sentinel/issues)
- Check [Azure Sentinel documentation](https://docs.microsoft.com/en-us/azure/sentinel/)
- Contact Secon Cyber support team

---

## 📁 Repository Structure

```
Azure Sentinel V2/
├── azuredeploy.json              # Full Sentinel deployment
├── azuredeploy.parameters.json   # Parameter template
├── automationrule.json           # Standalone automation rule
├── createUiDefinition.json       # Azure portal UI definition
└── README.md                     # This file
```
