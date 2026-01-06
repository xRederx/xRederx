# 🔐 Identity & Access Management Labs

Deep dive into IAM policies, Role-Based Access Control (RBAC), and zero-trust architecture implementations across cloud platforms.  This portfolio demonstrates expertise in identity security, authentication, and authorization.

---

## 📚 Lab Categories

### 🎯 AWS IAM

#### Policy Design & Management
- **Least Privilege Policies**: Creating minimal permission sets
- **Permission Boundaries**: Implementing delegation limits
- **Service Control Policies**: Organization-wide access control
- **Policy Simulation**: Testing and validating permissions
- **Cross-Account Access**: Trust relationships and role assumption

#### IAM Best Practices
- **IAM Access Analyzer**: Identifying external access
- **Credential Rotation**: Automated key and password rotation
- **MFA Enforcement**: Requiring multi-factor authentication
- **Session Management**: Temporary credentials and session tokens
- **IAM Roles for Services**: Service-to-service authentication

### 🔷 Azure Entra ID (Azure AD)

#### Identity Management
- **User & Group Management**: Organizing identities effectively
- **Conditional Access Policies**: Context-aware access control
- **Privileged Identity Management (PIM)**: Just-in-time admin access
- **Identity Protection**: Risk-based authentication
- **Guest User Management**: B2B collaboration security

#### Advanced Features
- **Managed Identities**: Service authentication without credentials
- **Service Principals**: Application identity management
- **Application Registration**: OAuth and API security
- **RBAC Assignment**: Azure resource access control
- **Access Reviews**: Periodic permission auditing

### 🛡️ Zero Trust Architecture

#### Principles Implementation
- **Never Trust, Always Verify**: Continuous authentication
- **Least Privilege Access**: Minimal necessary permissions
- **Assume Breach**: Defense in depth strategies
- **Explicit Verification**: Multi-factor validation
- **Microsegmentation**: Network and identity segmentation

#### Zero Trust Components
- **Identity Verification**: Strong authentication mechanisms
- **Device Compliance**: Endpoint security requirements
- **Continuous Monitoring**:  Real-time access decisions
- **Encrypted Communications**: End-to-end encryption
- **Analytics & Intelligence**: Behavioral analysis

### 🔑 Federation & SSO

- **SAML Integration**: Enterprise SSO implementation
- **OAuth 2.0 & OpenID Connect**: Modern authentication protocols
- **Federation Trusts**: Cross-organization authentication
- **Social Identity Providers**: External identity integration
- **API Authentication**: Token-based security

---

## 🎯 Featured Labs

### Lab 1: Implementing Least Privilege IAM in AWS
**Objective**: Design and implement minimal permission policies  
**Duration**: 4 hours  
**Difficulty**:  Intermediate

**What You'll Learn**:
- IAM policy syntax and structure
- Permission boundary implementation
- Access Analyzer integration
- Policy testing and validation

**Technologies**:  AWS IAM, Access Analyzer, CloudTrail, Python (Boto3)

**Key Achievements**:
- ✅ Created 15+ role-based policies
- ✅ Implemented permission boundaries
- ✅ Automated policy testing
- ✅ Documented policy templates

---

### Lab 2: Azure Conditional Access with Risk-Based Policies
**Objective**: Configure adaptive access controls based on risk signals  
**Duration**: 3 hours  
**Difficulty**:  Advanced

**What You'll Learn**: 
- Conditional Access policy design
- Risk detection configuration
- MFA enforcement strategies
- Sign-in logs analysis

**Technologies**: Azure Entra ID, Conditional Access, Identity Protection, KQL

**Key Achievements**: 
- ✅ Configured 10+ conditional access policies
- ✅ Implemented risk-based MFA
- ✅ Created location-based restrictions
- ✅ Set up device compliance requirements

---

### Lab 3: Cross-Account Access Strategy in AWS
**Objective**: Secure multi-account resource sharing  
**Duration**: 5 hours  
**Difficulty**:  Advanced

**What You'll Learn**:
- Trust policy configuration
- External ID implementation
- Cross-account role assumption
- AWS Organizations integration

**Technologies**: AWS IAM, Organizations, STS, CloudFormation

**Key Achievements**:
- ✅ Designed hub-and-spoke account architecture
- ✅ Implemented secure cross-account access
- ✅ Automated role provisioning with IaC
- ✅ Created audit logging for cross-account access

---

### Lab 4: Privileged Identity Management (PIM) in Azure
**Objective**: Implement just-in-time privileged access  
**Duration**: 4 hours  
**Difficulty**: Intermediate

**What You'll Learn**:
- PIM role activation workflows
- Approval processes configuration
- Access reviews setup
- Audit logging and reporting

**Technologies**: Azure Entra ID PIM, Azure Monitor, Logic Apps

**Key Achievements**:
- ✅ Configured JIT admin access
- ✅ Implemented approval workflows
- ✅ Set up quarterly access reviews
- ✅ Created PIM alert automation

---

### Lab 5: Zero Trust Identity Architecture
**Objective**: Design and implement comprehensive zero-trust identity model  
**Duration**: 8 hours  
**Difficulty**:  Expert

**What You'll Learn**: 
- Zero-trust principles application
- Multi-layered verification
- Continuous authentication
- Adaptive access policies

**Technologies**: AWS IAM, Azure Entra ID, SSO, MFA, Device Management

**Key Achievements**: 
- ✅ Designed complete zero-trust architecture
- ✅ Implemented device compliance checks
- ✅ Configured continuous access evaluation
- ✅ Created documentation and runbooks

---

### Lab 6: Federated Identity with SAML/OAuth
**Objective**: Implement enterprise SSO with external identity providers  
**Duration**: 6 hours  
**Difficulty**: Advanced

**What You'll Learn**:
- SAML configuration
- OAuth 2.0 flows
- Token validation
- Identity provider integration

**Technologies**: Azure Entra ID, Okta, AWS IAM Identity Center, OAuth, SAML

**Key Achievements**:
- ✅ Configured SAML federation
- ✅ Implemented OAuth 2.0 flows
- ✅ Integrated multiple identity providers
- ✅ Created automated provisioning

---

## 🛠️ Technologies & Skills

### Cloud Platforms
- **AWS**: IAM, Organizations, Access Analyzer, STS, Identity Center
- **Azure**: Entra ID, Conditional Access, PIM, Identity Protection

### Authentication & Authorization
- **Protocols**:  SAML 2.0, OAuth 2.0, OpenID Connect, LDAP
- **Standards**: Zero Trust, NIST 800-63, CIS Benchmarks
- **Methods**: MFA, Biometrics, Certificate-based, Token-based

### Tools & Automation
- **Scripting**: Python (Boto3), PowerShell, Azure CLI, AWS CLI
- **IaC**: Terraform, CloudFormation, ARM Templates
- **Monitoring**: CloudTrail, Azure Monitor, Log Analytics
- **Analysis**: KQL, SQL, JSON policy analysis

---

## 📊 IAM Security Frameworks

### CIS Benchmarks
- Identity and Access Management controls
- MFA enforcement
- Credential management
- Privileged access controls

### NIST 800-63
- Digital identity guidelines
- Authentication assurance levels
- Federation and assertions
- Identity proofing

### Zero Trust Maturity Model
- Identity maturity assessment
- Implementation roadmap
- Continuous improvement

---

## 🎓 Key Concepts Mastered

### AWS IAM
- ✅ Policy evaluation logic
- ✅ Permission boundaries
- ✅ Service control policies
- ✅ Cross-account access
- ✅ ABAC (Attribute-Based Access Control)

### Azure Entra ID
- ✅ Conditional Access
- ✅ Privileged Identity Management
- ✅ Managed identities
- ✅ App registration and consent
- ✅ Administrative units

### Security Principles
- ✅ Least privilege
- ✅ Defense in depth
- ✅ Separation of duties
- ✅ Zero trust
- ✅ Just-in-time access

---

## 📖 Resources & References

- [AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [Azure Identity Security](https://docs.microsoft.com/azure/security/fundamentals/identity-management-best-practices)
- [NIST Zero Trust Architecture](https://www.nist.gov/publications/zero-trust-architecture)
- [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp. org/cheatsheets/Authentication_Cheat_Sheet.html)

---

## 🚀 Lab Structure

Each IAM lab includes: 

- 📋 **Prerequisites**: Required knowledge and resources
- 🎯 **Objectives**: Clear learning goals
- 🏗️ **Architecture**: Identity flow diagrams
- 🔧 **Step-by-Step Guide**: Detailed implementation
- 💻 **Code Samples**: Scripts and configurations
- ✅ **Validation**: Testing procedures
- 🔍 **Troubleshooting**: Common issues and solutions
- 📊 **Analysis**: Security posture evaluation
- 🎓 **Key Takeaways**: Lessons learned

---

## 📈 Progress Tracking

| Lab Name | Cloud Platform | Status | Completion Date |
|----------|----------------|--------|-----------------|
| Least Privilege IAM | AWS | ✅ Completed | Dec 2025 |
| Conditional Access | Azure | ✅ Completed | Dec 2025 |
| Cross-Account Access | AWS | ✅ Completed | Jan 2026 |
| Azure PIM | Azure | 🚧 In Progress | - |
| Zero Trust Architecture | Multi-Cloud | 📋 Planned | - |
| Federated Identity | Multi-Cloud | 📋 Planned | - |

---

[← Back to Main Portfolio](../../README.md)
