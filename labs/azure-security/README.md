# 🔷 Azure Security Labs

Welcome to my Azure Security Labs portfolio! This collection demonstrates practical experience with Azure security features, identity management, and compliance frameworks.

---

## 📚 Lab Categories

### 🔐 Identity & Access Management
- **Entra ID Configuration**: User, group, and role management
- **Conditional Access Policies**: Zero-trust access controls
- **Privileged Identity Management (PIM)**: Just-in-time privileged access
- **Multi-Factor Authentication**:  Implementing MFA policies
- **Azure AD B2B/B2C**: External identity management

### 🛡️ Network Security
- **Network Security Groups (NSGs)**: Traffic filtering and segmentation
- **Azure Firewall**: Centralized network protection
- **Application Gateway WAF**: Web application firewall implementation
- **DDoS Protection**: Implementing DDoS mitigation
- **Private Endpoints**: Securing PaaS services

### 🔒 Data Protection
- **Azure Key Vault**:  Secrets, keys, and certificate management
- **Storage Account Security**: Encryption, SAS tokens, and access policies
- **Azure Information Protection**: Data classification and protection
- **Customer-Managed Keys**:  Implementing BYOK scenarios
- **Database Security**: Transparent Data Encryption and Always Encrypted

### 📊 Security Monitoring & Compliance
- **Microsoft Defender for Cloud**: Security posture management
- **Microsoft Sentinel**:  SIEM and SOAR implementation
- **Azure Monitor & Log Analytics**: Security logging and alerting
- **Azure Policy**: Compliance and governance automation
- **Secure Score Optimization**: Improving security posture

### ☁️ Secure DevOps
- **Azure DevOps Security**: Pipeline security and secret management
- **Container Security**: AKS security best practices
- **Infrastructure as Code**:  Secure Terraform and ARM templates
- **Security Scanning**:  Integrating security tools in CI/CD

---

## 🎯 Featured Projects

SecDevOps Automated-Cloud-Security-Pipeline: Container Hardening & IaC Governance
**Description**: End-to-end security practices for containerized applications with container hardening, IaC governance, and secure Azure deployment  
**Tools**:  Trivy, Docker, Terraform, Azure CLI, npm  
**Completion Status**: ✅ Completed (January 6, 2026)

**Features**:
- Container image vulnerability scanning with Trivy
- Security vulnerability remediation (CVE-2019-10744 resolved)
- Infrastructure as Code deployment with Terraform
- Network security implementation with Azure NSG
- Least-privilege firewall configuration (HTTPS-only inbound)
- Defense-in-depth security approach

**Key Achievements**:
- Successfully remediated CVE-2019-10744 (Lodash Prototype Pollution) using npm package overrides
- Documented CVE-2023-46233 (crypto-js) nested dependency limitations as accepted risk
- Deployed secure Azure infrastructure (VNet, Subnet, NSG with custom security rules)
- Implemented deny-all-except-necessary network security posture
- Created comprehensive documentation with 20 screenshots

**Technologies**: Docker, Trivy, Terraform, Azure (Resource Groups, Virtual Networks, NSGs), Node.js, Azure CLI

**Repository**: [SecDevOps Ter-doc-triv lab](https://github.com/xRederx/xRederx/blob/main/labs/security-tools/SecDevOps%20Automated-Cloud-Security-Pipeline%3A%20Container%20Hardening%20%26%20IaC%20Governance/README.md)

---

### Zero Trust Architecture with Conditional Access
**Description**: Implement granular access controls based on user identity, device health, location, and risk signals  
**Tools**:  Entra ID, Conditional Access, MFA, Intune, Azure AD Identity Protection  
**Completion Status**:  📋 Planned

**Features**:
- Risk-based conditional access policies
- Device compliance enforcement
- MFA configuration and enforcement
- Location-based access controls
- Session controls and sign-in frequency
- Continuous access evaluation (CAE)

**Repository**: [Link to project]

---

### Microsoft Defender for Cloud Implementation
**Description**: Enable comprehensive security posture management and threat protection across Azure subscriptions  
**Tools**:  Defender for Cloud, Azure Policy, Security Center, Log Analytics  
**Completion Status**:  📋 Planned

**Features**:
- Multi-subscription security coverage
- Workload protection plans activation
- Security recommendations implementation
- Secure score optimization
- Regulatory compliance dashboard
- Automated remediation with Logic Apps

**Repository**: [Link to project]

---

### Azure Key Vault with Customer-Managed Keys
**Description**:  Implement end-to-end encryption with bring-your-own-key (BYOK) across Azure services  
**Tools**: Azure Key Vault, Storage Accounts, Managed Identities, Azure Policy  
**Completion Status**: 📋 Planned

**Features**:
- Key Vault deployment with RBAC
- Customer-managed encryption keys
- Managed identity authentication
- Key rotation automation
- Soft delete and purge protection
- Integration with Storage and SQL Database

**Repository**: [Link to project]

---

### Sentinel SIEM Deployment & Threat Hunting
**Description**: Deploy cloud-native SIEM solution with automated threat detection and response  
**Tools**: Microsoft Sentinel, Log Analytics, Logic Apps, KQL, Watchlists  
**Completion Status**: 📋 Planned

**Features**:
- Multi-source data connector configuration
- Custom analytics rules creation
- KQL-based threat hunting queries
- Automated incident response playbooks
- Threat intelligence integration
- Custom workbooks and dashboards

**Repository**:  [Link to project]

---

### Secure AKS Cluster Deployment
**Description**: Deploy production-ready Kubernetes cluster with defense-in-depth security controls  
**Tools**: AKS, Azure Policy, Defender for Containers, Azure CNI, Calico  
**Completion Status**:  📋 Planned

**Features**:
- Azure Policy for Kubernetes enforcement
- Pod Security Standards implementation
- Network policies with Calico
- Azure AD workload identity
- Container image scanning
- Defender for Containers integration

**Repository**:  [Link to project]

---

### Azure Network Security Architecture
**Description**: Design and implement comprehensive network security controls with hub-spoke topology  
**Tools**: Azure Firewall, NSGs, Application Gateway WAF, Private Endpoints, DDoS Protection  
**Completion Status**: 📋 Planned

**Features**:
- Hub-spoke network architecture
- Azure Firewall with threat intelligence
- WAF policy configuration
- Micro-segmentation with NSGs
- Private endpoint implementation
- DDoS protection standard deployment

**Repository**: [Link to project]

---

### Automated Security Compliance Framework
**Description**: Continuous compliance checking and enforcement across Azure environment  
**Tools**:  Azure Policy, Blueprints, Terraform, PowerShell, DevOps Pipelines  
**Completion Status**: 📋 Planned

**Features**:
- Custom Azure Policy definitions
- Azure Blueprints for governance
- Automated CIS benchmark checks
- Compliance report generation
- Policy remediation automation
- Infrastructure as Code scanning

**Repository**: [Link to project]

---

### Identity Governance & PIM Implementation
**Description**: Implement just-in-time privileged access and access lifecycle management  
**Tools**: Privileged Identity Management, Entra ID Governance, Access Reviews  
**Completion Status**:  📋 Planned

**Features**:
- PIM role activation workflows
- Time-bound privileged access
- Access review automation
- Entitlement management packages
- Privileged access monitoring
- Emergency access account protection

**Repository**: [Link to project]

---


## 🛠️ Technologies Used

- **Azure Services**:  Entra ID, Key Vault, Defender for Cloud, Sentinel, Policy, Monitor, Network Security Groups, Firewall
- **IaC Tools**:  Terraform, ARM Templates, Bicep
- **Scripting**: PowerShell, Azure CLI, Python
- **Security Tools**:  Trivy, Checkov, TFSec
- **Query Languages**: KQL (Kusto Query Language)

---

## 📖 Learning Resources

- [Azure Security Documentation](https://docs.microsoft.com/azure/security/)
- [Microsoft Security Best Practices](https://docs.microsoft.com/security/compass/)
- [Azure Security Benchmark](https://docs.microsoft.com/security/benchmark/azure/)
- [Microsoft Learn - Security Path](https://learn.microsoft.com/training/browse/?products=azure&roles=security-engineer)

---

## 🚀 Getting Started

Each lab includes: 
- 📋 Scenario and objectives
- 🏗️ Architecture diagrams
- 🔧 Configuration steps
- 💻 Scripts and code samples
- ✅ Testing and validation
- 📊 Results and analysis
- 🎓 Lessons learned

---

## 🎓 Relevant Certifications

- ✅ Microsoft Azure Fundamentals (AZ-900)
- 🎯 In Progress: Azure Security Engineer Associate (AZ-500)

---

[← Back to Main Portfolio](../../README.md)
