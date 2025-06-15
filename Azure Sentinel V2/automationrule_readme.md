# Microsoft Sentinel - Auto-Close Noisy Incidents

This template deploys a Microsoft Sentinel workspace with an automation rule that automatically closes noisy MFA denial incidents to reduce alert fatigue.

## Quick Deploy

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FJudeMagayon%2FAzure-Sentinel%2Fmain%2FAzure%2520Sentinel%2520V2%2Fautomationrule.json)

[![Visualize](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.svg?sanitize=true)](http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FJudeMagayon%2FAzure-Sentinel%2Fmain%2FAzure%2520Sentinel%2520V2%2Fautomationrule.json)

## What gets deployed

- **Log Analytics Workspace** - Foundation for Microsoft Sentinel
- **Automation Rule** - Auto-closes incidents containing "MFA Deny" in the title
- **Content Hub Solution** - Windows Security Events solution package
- **Alert Rule** - MFA Deny alert rule (initially disabled)

## Parameters

| Parameter | Description | Default Value |
|-----------|-------------|---------------|
| `workspaceName` | Name for the Sentinel workspace | *Required* |
| `location` | Azure region for deployment | `southeastasia` |
| `automationRuleName` | Name for the automation rule | `AutoCloseNoisyIncidents` |
| `contentHubSolutionName` | Content Hub solution to install | `WindowsSecurityEvents` |

## Prerequisites

- Azure subscription with appropriate permissions
- Microsoft Sentinel licensing
- Resource group for deployment

## Post-Deployment

1. **Review the automation rule** - Verify the conditions match your requirements
2. **Enable MFA alert rule** - Configure and enable the MFA Deny alert rule as needed
3. **Monitor incidents** - Watch for properly auto-closed incidents
4. **Adjust conditions** - Modify the automation rule if needed based on your environment

## Manual Deployment

### Using Azure CLI

```bash
# Create resource group
az group create --name "rg-sentinel-automation" --location "southeastasia"

# Deploy template
az deployment group create \
  --resource-group "rg-sentinel-automation" \
  --template-file "Azure Sentinel V2/automationrule.json" \
  --parameters workspaceName="your-workspace-name"
```

### Using PowerShell

```powershell
# Create resource group
New-AzResourceGroup -Name "rg-sentinel-automation" -Location "Southeast Asia"

# Deploy template
New-AzResourceGroupDeployment `
  -ResourceGroupName "rg-sentinel-automation" `
  -TemplateFile "Azure Sentinel V2/automationrule.json" `
  -workspaceName "your-workspace-name"
```

## Customization

### Modify Automation Rule Conditions

To change what incidents get auto-closed, edit the `conditions` array in the template:

```json
"conditions": [
  {
    "property": "Incident.Title",
    "operator": "Contains",
    "value": "Your Custom Text"
  }
]
```

### Add Multiple Conditions

```json
"conditions": [
  {
    "property": "Incident.Title",
    "operator": "Contains",
    "value": "MFA Deny"
  },
  {
    "property": "Incident.Severity",
    "operator": "Equals",
    "value": "Low"
  }
]
```

## Security Considerations

⚠️ **Important**: This automation rule will automatically close incidents. Ensure you:

- Test in a non-production environment first
- Review the incident conditions carefully
- Monitor for false positives
- Have proper logging and alerting for closed incidents

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the deployment
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For issues and questions:
- Create an [issue](https://github.com/JudeMagayon/Azure-Sentinel/issues)
- Check Azure Sentinel [documentation](https://docs.microsoft.com/en-us/azure/sentinel/)

---

**Note**: This template is located in the `Azure Sentinel V2` folder of the repository.
