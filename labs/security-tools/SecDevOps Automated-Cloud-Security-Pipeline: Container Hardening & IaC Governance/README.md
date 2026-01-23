# SecDevOps Automated-Cloud-Security-Pipeline: Container Hardening & IaC Governance

A hands-on Security DevOps project demonstrating container vulnerability scanning, remediation, and secure cloud infrastructure deployment using Terraform.

## Project Overview

This lab demonstrates end-to-end security practices for containerized applications deployed to Azure, including:
- Container image vulnerability scanning with Trivy
- Security vulnerability remediation
- Infrastructure as Code (IaC) with Terraform
- Network security implementation with Azure NSG (Network Security Group)
- Least-privilege firewall configuration

## Technologies Used

- **Docker** - Container platform
- **Trivy** - Vulnerability scanner for containers
- **Terraform** - Infrastructure as Code tool
- **Azure** - Cloud platform
- **Azure CLI** - Command-line interface for Azure
- **Node.js/npm** - Application runtime and package management
- **OWASP Juice Shop** - Intentionally vulnerable web application (for testing)

## Prerequisites

- Docker Desktop installed
- Trivy installed
- Terraform (>= 1.0.0)
- Azure CLI
- Active Azure subscription
- Git

## Project Workflow

### Phase 1: Container Security Scanning

1. **Pull and build the application**
   ```bash
   docker build -t juice-shop-secure .
   ```

2. **Scan for vulnerabilities with Trivy**
   ```bash
   trivy image --format json juice-shop-secure > trivy-results.json
   ```

3. **Identify critical vulnerabilities**
   - CVE-2023-46233: crypto-js PBKDF2 weakness
   - CVE-2019-10744: Lodash Prototype Pollution

### Phase 2: Vulnerability Remediation

#### CVE-2023-46233 (crypto-js)
**Issue**: crypto-js PBKDF2 defaults to SHA1 (insecure) with only 1 iteration instead of recommended 250,000+

**Fix Attempted**: Attempted to use npm package overrides in Dockerfile to force crypto-js to version 4.2.0
```dockerfile
RUN npm pkg set overrides.crypto-js=4.2.0
RUN npm install --omit=dev
```

**Result**: Vulnerability persists in nested dependency (pdfkit → crypto-js@3.3.0). Would require source code access or forking the repository to implement proper overrides. Documented as accepted risk for this lab environment.

#### CVE-2019-10744 (lodash)
**Issue**: Lodash Prototype Pollution vulnerability in nested dependencies

**Fix Applied**: Used npm package overrides to force lodash to version 4.17.12+
```dockerfile
RUN npm pkg set overrides.lodash=^4.17.12
```

**Result**: Vulnerability eliminated

### Phase 3: Azure Infrastructure Deployment

1. **Login to Azure**
   ```bash
   az login --use-device-code
   ```

2. **Register Azure Resource Providers**
   ```bash
   az provider register --namespace Microsoft.Network
   az provider register --namespace Microsoft.Compute
   az provider register --namespace Microsoft.Storage
   ```

3. **Verify provider registration**
   ```bash
   az provider show --namespace Microsoft.Network --query "registrationState"
   az provider show --namespace Microsoft.Compute --query "registrationState"
   az provider show --namespace Microsoft.Storage --query "registrationState"
   ```

4. **Deploy infrastructure with Terraform**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

### Phase 4: Network Security Configuration

**Network Security Group Rules Implemented:**

- Priority 100: Allow-HTTPS - Allows inbound TCP traffic on port 443
- Priority 4096: Deny-All-Inbound - Denies all other inbound traffic
- Priority 100: Allow-All-Outbound - Allows all outbound traffic

**Security Posture:**
- Only HTTPS (port 443) allowed inbound
- All other inbound traffic denied
- Outbound traffic allowed for updates and API calls
- Defense-in-depth approach

## Results

### Security Improvements

**Before:**
- CVE-2023-46233 (CRITICAL) - crypto-js weakness in nested dependency
- CVE-2019-10744 (HIGH) - Lodash Prototype Pollution
- Multiple nested dependency vulnerabilities

**After:**
- CVE-2023-46233 - **PARTIALLY MITIGATED** (nested dependency limitation documented)
- CVE-2019-10744 - **RESOLVED**
- Secure dependency versions enforced where possible
- Network-level security controls implemented

### Infrastructure Created

- Resource Group: `rg-secdevops-lab`
- Virtual Network: `vnet-secdevops-lab` (10.0.0.0/16)
- Subnet: `snet-secdevops-lab` (10.0.1.0/24)
- Network Security Group: `nsg-allow-specific-port`
- Security Rules: 3 custom rules + Azure defaults

## Security Best Practices Demonstrated

1. **Vulnerability Scanning**: Regular scanning of container images before deployment
2. **Dependency Management**: Using package overrides to enforce secure versions
3. **Infrastructure as Code**: Version-controlled, repeatable infrastructure
4. **Least Privilege**: Deny-all-except-necessary firewall rules
5. **Defense in Depth**: Multiple layers of security (container + network)
6. **Documentation**: Clear documentation for reproducibility

## Project Structure

```
SecDevOps Ter-doc-triv lab/
── Dockerfile                 # Container build configuration with security fixes
── main.tf                    # Terraform infrastructure configuration
── trivy-results.json         # Initial vulnerability scan results
── trivy-results-6.json       # Post-remediation scan results
── lock.txt                   # Lock file
── screenshots/               # Documentation screenshots   
── README.md                  # This file
```

## Screenshots

This lab includes 20 screenshots documenting the complete workflow from initial vulnerability scanning through successful Azure deployment:

### Phase 1: Container Security Scanning & Crypto-JS Remediation (01-10)

**01-docker-build-final-success.png**  
Final Docker build completing successfully

**02-trivy-results-json-cve-2023-46233-details.png**  
Detailed CVE-2023-46233 (crypto-js PBKDF2 weakness) vulnerability information in trivy-results.json

**03-npm-install-crypto-js-latest.png**  
Terminal output attempting to install crypto-js@latest to fix CVE-2023-46233

**04-trivy-results-json-cve-2023-46233-final.png**  
Trivy results showing CVE-2023-46233 still present after initial remediation attempts

**05-dockerfile-final-crypto-js-commented.png**  
Dockerfile showing crypto-js installation code (with VS Code lightbulb warning)

**06-trivy-results-2-cve-2023-46233-persists.png**  
trivy-results-2.json confirming CVE-2023-46233 persists in nested dependencies

**07-dockerfile-npm-force-resolutions.png**  
Dockerfile using npm-force-resolutions strategy to attempt dependency override

**08-trivy-scan-cve-2023-46233-crypto-js.png**  
trivy-results-3.json showing detailed CVE-2023-46233 analysis

**09-dockerfile-crypto-js-fix-attempt.png**  
Dockerfile with crypto-js@4.2.0 installation attempt highlighted

**10-trivy-new-vulnerability-persists.png**  
Discovering new vulnerability CVE-2019-10744 (lodash) alongside the persistent crypto-js issue

### Phase 2: Lodash Vulnerability Remediation (11-14)

**11-dockerfile-lodash-fix-attempt.png**  
Dockerfile with lodash@^4.17.12 package override added to fix CVE-2019-10744

**12-trivy-results-5-json-lodash-fixed.png**  
trivy-results-5.json showing results after lodash remediation attempt

**13-dockerfile-crypto-js-build.png**  
Dockerfile with both lodash and crypto-js overrides, running Docker build

**14-trivy-results-search-vulnerability-gone.png**  
Using Ctrl+F search to verify CVE-2019-10744 (lodash) vulnerability was successfully eliminated

### Phase 3: Azure Infrastructure Deployment Challenges (15-18)

**15-terraform-plan-nsg-rules.png**  
Running `terraform plan` showing planned NSG security rules (Allow-All-Outbound, Allow-HTTPS)

**16-terraform-apply-errors.png**  
Terraform apply errors - subscription region restrictions encountered

**17-terraform-destroy-restart.png**  
Running `terraform destroy` to clean up resources and restart deployment

**18-az-account-check-region-restriction.png**  
Checking available Azure regions with `az account list-locations` - identified school Azure account restrictions

### Phase 4: Successful Deployment (19-20)

**19-terraform-apply-success-personal-account.png**  
Terraform apply successful after switching to personal Azure account - "Apply complete! Resources: 8 added, 0 changed, 0 destroyed"

**20-azure-portal-nsg-rules-proof.png**  
Azure Portal showing nsg-allow-specific-port with successfully created Inbound Security Rules (Allow-HTTPS, Deny-All-Inbound) and Outbound Security Rules (Allow-All-Outbound) - PROOF OF SUCCESSFUL DEPLOYMENT

### Key Workflow Insights

1. **CVE-2023-46233** (crypto-js): Attempted multiple remediation strategies but vulnerability persisted due to nested dependency (pdfkit → crypto-js@3.3.0). Documented as accepted risk for lab environment.

2. **CVE-2019-10744** (lodash): Successfully remediated using npm package overrides (`overrides.lodash=^4.17.12`)

3. **Azure Deployment Challenge**: Initial deployment failed due to school Azure account restrictions. Successfully resolved by switching to personal Azure subscription.

4. **Infrastructure Success**: All Azure resources (Resource Group, Virtual Network, Subnet, NSG with security rules) deployed successfully with least-privilege network security configuration.

## Cleanup

To destroy all Azure resources when done:

```bash
terraform destroy
```

Or manually via Azure CLI:

```bash
az group delete --name rg-secdevops-lab --yes --no-wait
```

## Lessons Learned

1. **Nested Dependencies**: Vulnerabilities in nested dependencies require package overrides, not direct updates
2. **Azure Policies**: Student subscriptions have region restrictions that must be considered
3. **Provider Registration**: Manually registering Azure providers prevents timeout issues
4. **Security Scanning**: Early and frequent scanning catches vulnerabilities before production
5. **IaC Benefits**: Terraform enables reproducible, documented infrastructure

## Skills Demonstrated

- Container security and vulnerability management
- Docker containerization
- Infrastructure as Code (Terraform)
- Azure cloud platform
- Network security configuration
- Security scanning tools (Trivy)
- Package dependency management
- DevSecOps practices
- Technical documentation

## Notes

- This lab uses OWASP Juice Shop, an intentionally vulnerable application designed for security training
- All resources deployed in this lab should be destroyed after completion to avoid unnecessary Azure costs
- The configuration prioritizes security learning over application functionality

## References

- [CVE-2023-46233 Details](https://avd.aquasec.com/nvd/cve-2023-46233)
- [CVE-2019-10744 Details](https://github.com/advisories/GHSA-jf85-cpcp-j695)
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Network Security Groups](https://docs.microsoft.com/azure/virtual-network/network-security-groups-overview)

## Author

**John** - Aspiring Cloud Security Engineer/Architect  
*Completing Master's degree and building portfolio for cloud security roles*

---

**Date Completed**: January 6, 2026  
**Project Type**: Security DevOps Lab  
**Purpose**: Portfolio demonstration for cloud security engineering positions
