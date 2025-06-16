# Azure Sentinel Onboarding Workflow

This repository contains automated deployment templates and configurations for onboarding Azure Sentinel (Microsoft Sentinel) in your environment.

## 📋 Overview

This workflow provides a comprehensive solution for deploying and configuring Azure Sentinel with:
- Automated ARM template deployment
- Pre-configured analytics rules and hunting queries
- Playbook automation
- Multi-tenant support
- Watchlist management
- Custom connectors and data sources

## 🏗️ Repository Structure

```
AZURE-SENTINEL/
├── Azure Sentinel ARM/
│   ├── Connector/              # Data connector configurations
│   ├── Hunting Queries/        # Pre-built hunting queries
│   ├── LinkedTemplates/        # Linked ARM templates
│   ├── Playbooks/             # Logic Apps automation playbooks
│   ├── Rules/                 # Analytics rules
│   ├── Scripts/               # Deployment and configuration scripts
│   └── Watchlists/            # Threat intelligence watchlists
├── automationrule_readme.md   # Automation rules documentation
├── automationrule.json        # Automation rule definitions
├── AZ_Sentinel_Analytics_Rules_Editor.py  # Analytics rules management tool
├── azuredeploy.json           # Main ARM deployment template
├── createUiDefinition.json    # Azure portal UI definition
├── manual-steps               # Manual configuration steps
├── Multi-Tenant-LH            # Lighthouse multi-tenant setup
├── Multi-Tenant-LH eligible authorizations  # Authorization configurations
└── Azure Sentinel IAC/        # Infrastructure as Code templates
```

## 🚀 Quick Start

### Prerequisites

- Azure subscription with appropriate permissions
- Azure CLI or PowerShell installed
- Contributor access to target resource group
- Log Analytics workspace (will be created if doesn't exist)

### 1. Deploy Core Infrastructure

```bash
# Clone the repository
git clone <repository-url>
cd azure-sentinel

# Deploy using Azure CLI
az deployment group create \
  --resource-group <your-rg> \
  --template-file azuredeploy.json \
  --parameters @parameters.json
```

### 2. Configure Data Connectors

Navigate to the `Connector/` folder and deploy the relevant data connectors for your environment:

```bash
# Example: Deploy Office 365 connector
az deployment group create \
  --resource-group <your-rg> \
  --template-file Connector/office365-connector.json
```

### 3. Deploy Analytics Rules

```bash
# Deploy all analytics rules
az deployment group create \
  --resource-group <your-rg> \
  --template-file Rules/analytics-rules.json
```

### 4. Setup Automation Rules

```bash
# Deploy automation rules
az deployment group create \
  --resource-group <your-rg> \
  --template-file automationrule.json
```

## 🔧 Configuration

### Analytics Rules Management

Use the Python script to manage analytics rules:

```bash
python AZ_Sentinel_Analytics_Rules_Editor.py
```

This tool allows you to:
- Create new analytics rules
- Modify existing rules
- Export/import rule configurations
- Bulk operations on multiple rules

### Manual Configuration Steps

Some configurations require manual intervention. Check the `manual-steps` file for:
- Custom connector setup
- Third-party integrations
- Advanced hunting configurations
- Workspace-specific settings

### Multi-Tenant Setup

For multi-tenant environments using Azure Lighthouse:

1. Review `Multi-Tenant-LH/` configurations
2. Deploy Lighthouse authorizations
3. Configure cross-tenant permissions
4. Validate access across tenants

## 📊 Components

### Data Connectors
- Office 365
- Azure Active Directory
- Azure Security Center
- Custom API connectors
- Syslog/CEF sources

### Analytics Rules
- MITRE ATT&CK mapped detections
- Custom threat hunting rules
- Behavioral analytics
- Machine learning anomalies

### Playbooks
- Incident response automation
- Threat hunting workflows
- Integration with ITSM tools
- Custom remediation actions

### Watchlists
- Threat intelligence feeds
- Known good/bad indicators
- Asset inventories
- User group mappings

## 🔍 Hunting Queries

Pre-built hunting queries are available in the `Hunting Queries/` folder, organized by:
- MITRE ATT&CK techniques
- Data source types
- Threat categories
- Difficulty levels

## 🛡️ Security Considerations

- Review all templates before deployment
- Ensure proper RBAC configurations
- Validate data retention policies
- Configure appropriate alert thresholds
- Regular review of automation rules

## 📖 Documentation

- `automationrule_readme.md` - Detailed automation rules documentation
- `createUiDefinition.json` - Portal deployment UI reference
- Individual component READMEs in respective folders

## 🔄 Maintenance

### Regular Tasks
- Update analytics rules monthly
- Review and tune alert thresholds
- Update threat intelligence watchlists
- Validate automation rule effectiveness
- Monitor data connector health

### Monitoring
- Check data ingestion rates
- Monitor alert volume and quality
- Review automation rule execution logs
- Validate hunting query performance

## 🆘 Troubleshooting

### Common Issues
1. **Deployment Failures**: Check ARM template parameters and permissions
2. **Data Connector Issues**: Verify API permissions and network connectivity
3. **Alert Fatigue**: Review and tune analytics rule thresholds
4. **Automation Failures**: Check Logic App execution history

### Support Resources
- Azure Sentinel documentation
- Community GitHub repositories
- Microsoft Security blog
- Azure support tickets for critical issues

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Test changes in non-production environment
4. Submit pull request with detailed description

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🏷️ Tags

`azure-sentinel` `security` `siem` `arm-templates` `automation` `threat-hunting` `incident-response`

---

**⚠️ Important**: Always test deployments in a non-production environment first. Review all configurations for your specific security requirements before deploying to production.
