# 🔐 DevSecOps & CI/CD Security Labs

Welcome to my DevSecOps & CI/CD Security Labs portfolio! This collection showcases hands-on projects focused on secure pipeline design, shift-left security enforcement, Infrastructure as Code (IaC) governance, and automated self-healing cloud security architectures.

---

## 📚 Lab Categories

### 🔁 CI/CD Architecture & Release Engineering
- **Pipeline Design & Optimization**: Building scalable, resilient CI/CD workflows
- **Multi-Environment Deployment Strategies**: Dev, staging, and production orchestration
- **Runner & Build Agent Management**: Secure and efficient execution environments
- **Release Automation & Versioning**: Controlled build and deployment lifecycle management

### 🛡️ DevSecOps Integration
- **Security Embedded in the SDLC**: Integrating controls throughout development stages
- **Automated Security Testing**: SAST, DAST, and pipeline-integrated scanning
- **Secure Code Review Enforcement**: Policy-driven pull request validation
- **Compliance Alignment**: Mapping pipelines to industry security standards

### 📦 Supply Chain & Artifact Security
- **Dependency Risk Management**: Monitoring third-party libraries and packages
- **Artifact Integrity & Signing**: Ensuring authenticity of builds and releases
- **SBOM Generation & Analysis**: Software component visibility and traceability
- **Container & Registry Governance**: Secure image management practices

### 🏗️ Infrastructure & Platform Automation
- **Infrastructure as Code Workflows**: Automated provisioning and lifecycle management
- **Configuration Management**: Standardizing infrastructure across environments
- **Cloud & Platform Integration**: Connecting CI/CD systems with cloud-native services
- **Scalable Automation Frameworks**: Designing reusable infrastructure pipelines

### 📊 Continuous Monitoring & Operational Resilience
- **Pipeline Observability**: Logging, metrics, and workflow visibility
- **Drift Detection & Change Monitoring**: Identifying unauthorized configuration changes
- **Automated Remediation Workflows**: Event-driven corrective actions
- **Resilience & Recovery Strategies**: Designing fault-tolerant deployment systems

---

## 🎯 Featured Labs

### AI-Powered Chat API (.NET + OpenAI)
**Description**: ASP.NET Core REST API built in C# that accepts user prompts and returns real-time AI-generated responses via OpenAI's gpt-4o-mini model. Demonstrates secure credential management, minimal API architecture, and AI integration in a .NET environment.

**Tools**: .NET 9, C#, ASP.NET Core, OpenAI SDK, IConfiguration, PowerShell

**Completion Status**: ✅ Complete

**Features**:
- Single-file minimal API with a clean `POST /chat` endpoint
- Integrated OpenAI gpt-4o-mini for real-time prompt completion
- Secure API key management via ASP.NET `IConfiguration` — never hardcoded
- `appsettings.json` excluded from source control via `.gitignore`
- `appsettings.example.json` committed for contributor onboarding
- Full build log documenting Azure OpenAI quota issues, SDK migration, and troubleshooting steps

**Repository**: [Link to project](https://github.com/xRederx/xRederx/blob/main/labs/devsecops-cicd/ai-chat-api/README.md)

---

### Self-Healing DevSecOps Security Pipeline  
**Description**: End-to-end DevSecOps security architecture that enforces shift-left IaC scanning, secure Terraform state management, continuous cloud monitoring, and automated self-healing remediation of insecure network configurations  
**Tools**: pre-commit, Checkov, Trivy, Terraform, Azure Blob Storage, Python (azure-mgmt-network), GitHub Actions  
**Completion Status**: 🚧 In Progress  

**Features**:
- Pre-commit Git hooks enforcing Terraform security scanning before code commit  
- Automated IaC scanning using Checkov and Trivy  
- Secure Terraform remote state storage in Azure Blob Storage  
- Deployment of Azure Network Security Group (NSG) with least-privilege rules  
- Scheduled GitHub Actions workflow (cron) for continuous NSG monitoring  
- Automated detection and self-healing remediation of exposed SSH (port 22) rules  

**Repository**: [Link to project]

---

## 🛠️ Technologies Used

- **CI/CD Tools**: GitHub Actions
- **IaC Tools**: Terraform
- **Cloud Platform**: Microsoft Azure
- **Security Tools**: Checkov, Trivy, pre-commit
- **Programming**: Python (Azure SDK), HCL
- **Version Control**: Git

---

## 📖 Learning Resources

- [GitHub Actions Documentation](https://docs.github.com/actions)
- [Terraform Best Practices](https://developer.hashicorp.com/terraform/docs)
- [Azure SDK for Python](https://learn.microsoft.com/azure/developer/python/)
- [Checkov Documentation](https://www.checkov.io/)
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)

---

## 🚀 Getting Started

Each lab includes:
- 📋 Detailed objectives and real-world scenario
- 🏗️ Infrastructure architecture explanation
- 🔧 Step-by-step implementation guide
- 💻 Code samples and automation scripts
- ✅ Validation and remediation testing
- 📊 Security analysis and lessons learned

---

[← Back to Main Portfolio](../../README.md)
