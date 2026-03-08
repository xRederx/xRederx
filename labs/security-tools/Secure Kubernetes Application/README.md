# Secure Kubernetes Application with Automated Incident Response

A hands-on Security DevOps project demonstrating automated Kubernetes threat detection, pod quarantine, traffic isolation via a service mesh, and real-time email alerting.

## Project Overview

This lab demonstrates end-to-end Kubernetes security practices for a containerized multi-tier application running on a local cluster, including:
- Kubernetes application deployment and cluster configuration
- Zero Trust network segmentation with NetworkPolicies
- Service mesh deployment with Istio and mutual TLS (mTLS) enforcement
- Automated suspicious pod detection with Trivy vulnerability scanning
- Pod quarantine labeling and traffic isolation via Istio AuthorizationPolicy
- Scheduled automation for continuous monitoring
- Real-time email alerting on quarantine events
- Secure secret management with environment variables

## Technologies Used

- **Minikube** - Local Kubernetes cluster
- **kubectl** - Kubernetes command-line tool
- **Docker** - Container platform
- **Istio 1.25.1** - Service mesh (mTLS, Gateway, AuthorizationPolicy)
- **Trivy** - Vulnerability scanner for container images
- **Python** - Automation scripting (kubernetes client, smtplib, python-dotenv)
- **Kubernetes Python Client** - Programmatic cluster interaction
- **Gmail SMTP** - Email notification delivery
- **Google Kubernetes Engine Guestbook App** - Multi-tier demo application (frontend + Redis)

## Prerequisites

- Docker Desktop installed
- Minikube installed
- kubectl installed
- Istio 1.25.1 installed (`istioctl`)
- Trivy installed
- Python 3.x with pip
- Git

## Project Workflow

### Phase 1: Kubernetes Cluster & Application Deployment

1. **Start the Minikube cluster**
   ```bash
   minikube start
   ```

2. **Enable Istio injection on the default namespace**
   ```bash
   kubectl label namespace default istio-injection=enabled
   ```

3. **Deploy the Guestbook application (frontend + Redis leader + Redis followers)**
   ```bash
   kubectl apply -f redis-leader-deployment.yaml
   kubectl apply -f redis-leader-service.yaml
   kubectl apply -f redis-follower-deployment.yaml
   kubectl apply -f redis-follower-service.yaml
   kubectl apply -f frontend-deployment.yaml
   kubectl apply -f frontend-service.yaml
   ```

4. **Verify all pods are running**
   ```bash
   kubectl get pods
   kubectl get services
   ```

---

### Phase 2: Zero Trust Network Segmentation (NetworkPolicies)

**NetworkPolicies Applied:**

- `allow-frontend-to-redis-follower.yaml` - Allows frontend pods to reach Redis followers on port 6379
- `allow-redis-follower-to-redis-leader.yaml` - Allows Redis followers to reach the Redis leader on port 6379

```bash
kubectl apply -f allow-frontend-to-redis-follower.yaml
kubectl apply -f allow-redis-follower-to-redis-leader.yaml
```

**Note:** Minikube's default CNI does not enforce NetworkPolicies at the kernel level. These policies are defined for documentation and future CNI-compatible environments. Traffic isolation is enforced in this lab by Istio AuthorizationPolicy (see Phase 5).

---

### Phase 3: Istio Service Mesh & mTLS

1. **Install Istio with the demo profile**
   ```bash
   istioctl install --set profile=demo -y
   ```

2. **Apply strict mTLS across the default namespace**
   ```bash
   kubectl apply -f peer-authentication.yaml
   ```
   `peer-authentication.yaml` enforces `mode: STRICT`, requiring all pod-to-pod communication to use mutual TLS.

3. **Configure Istio Ingress Gateway and VirtualService**
   ```bash
   kubectl apply -f guestbook-gateway.yaml
   ```
   Routes external traffic through the Istio IngressGateway to the frontend service on port 80.

4. **Expose the IngressGateway and access the app**
   ```bash
   minikube tunnel
   kubectl get svc istio-ingressgateway -n istio-system
   ```
   Browse to the `EXTERNAL-IP` shown for `istio-ingressgateway`.

---

### Phase 4: Automated Pod Detection & Vulnerability Scanning

**`detect_pods.py`** is the main orchestration script. It:
- Connects to the cluster using the local kubeconfig
- Iterates all pods in the `default` namespace
- Flags pods that use `:latest` image tags, have high restart counts, or are not in `Running` state
- Runs **Trivy** on each pod's container image to detect HIGH and CRITICAL CVEs
- Writes all suspicious pod names to `quarantine_list.txt`
- Sends an email alert for each quarantined pod
- Calls `quarantine_pods.py` and `isolate_quarantined_pods.py` automatically

```bash
python detect_pods.py
```

**Example Trivy scan call (from detect_pods.py):**
```python
result = subprocess.run(
    ["trivy", "image", "--severity", "HIGH,CRITICAL", "--no-progress", image],
    capture_output=True, text=True, timeout=120, encoding="utf-8"
)
```

---

### Phase 5: Quarantine Labeling & Traffic Isolation

**Step 1 — Label suspicious pods (`quarantine_pods.py`)**

Reads `quarantine_list.txt` and patches each pod's metadata with `quarantine=true` using the Kubernetes API.

```python
v1.patch_namespaced_pod(name, "default", {"metadata": {"labels": {"quarantine": "true"}}})
```

**Step 2 — Apply deny-all NetworkPolicy (`isolate_quarantined_pods.py`)**

Creates (or replaces if already existing) a NetworkPolicy that blocks all ingress and egress for pods labeled `quarantine=true`.

```python
try:
    v1.create_namespaced_network_policy(namespace="default", body=policy)
except ApiException as e:
    if e.status == 409:
        v1.replace_namespaced_network_policy("quarantine-isolation", "default", policy)
```

**Step 3 — Enforce isolation via Istio AuthorizationPolicy (`deny-quarantine.yaml`)**

Because Minikube does not enforce NetworkPolicies, the **effective** traffic block is achieved through an Istio `AuthorizationPolicy` with empty rules — denying all traffic to matching pods.

```yaml
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: deny-quarantine
  namespace: default
spec:
  selector:
    matchLabels:
      quarantine: "true"
  rules: []
```

```bash
kubectl apply -f deny-quarantine.yaml
```

**To remove quarantine and restore access:**
```bash
kubectl label pods --all quarantine-
```

---

### Phase 6: Automation Scheduler

**`auto_detect_and_quarantine.py`** runs the full detection and response pipeline in an infinite loop, triggering `detect_pods.py` every 5 minutes.

```python
while True:
    subprocess.run(["python", "detect_pods.py"])
    time.sleep(300)
```

```bash
python auto_detect_and_quarantine.py
```

---

### Phase 7: Email Notifications

**`notifier.py`** sends Gmail SMTP alerts when a pod is quarantined. It loads the Gmail app password securely from a `.env` file.

```python
with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
    server.login(from_email, password)
    server.sendmail(from_email, to_email, msg.as_string())
```

**Setup:**
1. Generate a Gmail App Password (Google Account → Security → 2-Step Verification → App Passwords)
2. Add to `.env`:
   ```
   EMAIL_PASSWORD=your_app_password_here
   ```
3. Install dependency:
   ```bash
   pip install python-dotenv
   ```

---

### Phase 8: Secret Management

Credentials are kept out of source code using environment variables loaded via `python-dotenv`.

- **`.env`** — Stores `EMAIL_PASSWORD` (never committed to Git)
- **`.gitignore`** — Excludes `.env` from version control

```
# .gitignore
.env
```

---

## Results

### Security Controls Implemented

| Control | Method | Status |
|---|---|---|
| Zero Trust microsegmentation | Kubernetes NetworkPolicies | Applied |
| Mutual TLS (pod-to-pod) | Istio PeerAuthentication (STRICT) | Enforced |
| Ingress traffic control | Istio Gateway + VirtualService | Working |
| Vulnerability scanning | Trivy (HIGH/CRITICAL) | Working |
| Pod quarantine labeling | Kubernetes API patch | Working |
| Traffic denial for quarantined pods | Istio AuthorizationPolicy | Confirmed blocked |
| Continuous monitoring | Python scheduler (5 min interval) | Working |
| Real-time alerting | Gmail SMTP | Working |
| Secret management | python-dotenv + .gitignore | Secured |

### Key Discovery

NetworkPolicies are defined and applied but **not enforced** in Minikube's default CNI (bridge). Switching to **Istio AuthorizationPolicy** achieved confirmed traffic denial — browser access to the quarantined frontend returned a connection error, proving isolation was effective.

---

## Security Best Practices Demonstrated

1. **Vulnerability Scanning**: Automated Trivy scanning of live container images before quarantine decisions
2. **Zero Trust Networking**: Deny-by-default posture with explicit allow rules for required service communication
3. **Mutual TLS**: All pod-to-pod traffic encrypted and authenticated via Istio strict mTLS
4. **Automated Incident Response**: Detection-to-isolation pipeline runs without manual intervention
5. **Least Privilege**: AuthorizationPolicy denies all traffic to suspicious pods; only necessary paths are explicitly allowed
6. **Defense in Depth**: Multiple overlapping controls (NetworkPolicy + AuthorizationPolicy + mTLS)
7. **Secret Management**: Credentials stored in environment variables, excluded from version control
8. **Alerting**: Real-time notifications ensure operator awareness of quarantine events

---

## Project Structure

```
Secure Kubernetes Application/
├── detect_pods.py                          # Main detection + Trivy scan + orchestration
├── quarantine_pods.py                      # Labels suspicious pods quarantine=true
├── isolate_quarantined_pods.py             # Applies deny-all NetworkPolicy
├── auto_detect_and_quarantine.py           # Scheduler: runs pipeline every 5 minutes
├── notifier.py                             # Gmail SMTP email alert module
├── deny-quarantine.yaml                    # Istio AuthorizationPolicy (effective isolation)
├── peer-authentication.yaml               # Istio mTLS STRICT mode
├── guestbook-gateway.yaml                  # Istio Gateway + VirtualService
├── allow-frontend-to-redis-follower.yaml  # NetworkPolicy microsegmentation
├── allow-redis-follower-to-redis-leader.yaml
├── frontend-deployment.yaml
├── frontend-service.yaml
├── redis-leader-deployment.yaml
├── redis-leader-service.yaml
├── redis-follower-deployment.yaml
├── redis-follower-service.yaml
├── quarantine_list.txt                     # Runtime output: quarantined pod names
├── .env                                    # Secret: EMAIL_PASSWORD (not committed)
├── .gitignore                              # Excludes .env
└── README.md                               # This file
```

---

## Screenshots

### Phase 1: Cluster Setup & Application Deployment (01-04)

**[01-minikube-start.png](screenshots/01-minikube-start.png)**  
Minikube cluster starting successfully

**[02-kubectl-get-pods-running.png](screenshots/02-kubectl-get-pods-running.png)**  
All Guestbook pods (frontend ×3, redis-leader, redis-follower ×2) in Running state

**[03-guestbook-app-browser.png](screenshots/03-guestbook-app-browser.png)**  
Guestbook web application accessible via Istio IngressGateway external IP

**[04-kubectl-get-services.png](screenshots/04-kubectl-get-services.png)**  
All services listed including istio-ingressgateway with external IP assigned via `minikube tunnel`

### Phase 2 & 3: NetworkPolicies & Istio mTLS (05-08)

**[05-networkpolicies-applied.png](screenshots/05-networkpolicies-applied.png)**  
`kubectl get networkpolicies` showing allow-frontend-to-redis-follower and allow-redis-follower-to-redis-leader applied

**[06-peer-authentication-applied.png](screenshots/06-peer-authentication-applied.png)**  
`kubectl get peerauthentication` confirming STRICT mTLS mode in default namespace

**[07-guestbook-gateway-applied.png](screenshots/07-guestbook-gateway-applied.png)**  
Istio Gateway and VirtualService applied successfully

**[08-app-accessible-after-istio.png](screenshots/08-app-accessible-after-istio.png)**  
Guestbook app working correctly after Istio gateway configuration

### Phase 4: Detection & Trivy Scanning (09-11)

**[09-detect-pods-output.png](screenshots/09-detect-pods-output.png)**  
`detect_pods.py` terminal output showing Trivy scan running against pod images

**[10-trivy-vulnerabilities-found.png](screenshots/10-trivy-vulnerabilities-found.png)**  
Trivy output showing HIGH/CRITICAL CVEs in Guestbook container images

**[11-quarantine-list-txt.png](screenshots/11-quarantine-list-txt.png)**  
`quarantine_list.txt` populated with suspicious pod names after detection run

### Phase 5: Quarantine & Isolation (12-15)

**[12-pods-labeled-quarantine.png](screenshots/12-pods-labeled-quarantine.png)**  
`kubectl get pods --show-labels` showing quarantine=true label applied to flagged pods

**[13-networkpolicy-applied.png](screenshots/13-networkpolicy-applied.png)**  
Quarantine NetworkPolicy created via `isolate_quarantined_pods.py`

**[14-deny-quarantine-authpolicy-applied.png](screenshots/14-deny-quarantine-authpolicy-applied.png)**  
`kubectl get authorizationpolicy` showing deny-quarantine policy active

**[15-browser-access-denied-quarantine.png](screenshots/15-browser-access-denied-quarantine.png)**  
Browser showing connection refused/error after quarantine label applied — PROOF of effective traffic isolation via Istio AuthorizationPolicy

### Phase 6-8: Automation, Alerting & Secrets (16-19)

**[16-auto-scheduler-running.png](screenshots/16-auto-scheduler-running.png)**  
`auto_detect_and_quarantine.py` running in terminal, showing continuous 5-minute cycle

**[17-email-notification-received.png](screenshots/17-email-notification-received.png)**  
Gmail inbox showing "Kubernetes Quarantine Alert" email received after pod quarantine event

**[18-env-file-gitignore.png](screenshots/18-env-file-gitignore.png)**  
`.env` and `.gitignore` files confirming secret management setup

**[19-access-restored-label-removed.png](screenshots/19-access-restored-label-removed.png)**  
`kubectl label pods --all quarantine-` and browser showing app accessible again after label removal

---

## Key Workflow Insights

1. **Minikube CNI does not enforce NetworkPolicies**: The default Minikube networking bridge does not implement NetworkPolicy at the kernel level. Policies are applied but ignored at runtime. Discovered when quarantined pods remained accessible in the browser despite a deny-all NetworkPolicy being present.

2. **Istio AuthorizationPolicy is the effective isolation mechanism**: Applying an `AuthorizationPolicy` with `rules: []` to pods labeled `quarantine=true` caused immediate and confirmed traffic denial. This is the correct enforcement path when running Istio in Minikube.

3. **mTLS broke application access initially**: Enabling `PeerAuthentication` in STRICT mode without configuring an ingress path caused the app to become unreachable. Resolved by deploying `guestbook-gateway.yaml` (Istio Gateway + VirtualService) to route external traffic through the IngressGateway.

4. **NetworkPolicy 409 conflict on repeated runs**: Re-running `isolate_quarantined_pods.py` threw an `AlreadyExists` API error. Resolved with a try/except block that calls `replace_namespaced_network_policy` when status code is 409.

5. **Windows encoding error with Trivy**: `subprocess.run()` defaulted to the system code page on Windows, causing `UnicodeDecodeError` when parsing Trivy output. Resolved by explicitly setting `encoding="utf-8"`.

6. **NoneType crash on Trivy scan failure**: `result.stdout` returned `None` for failed scans. Resolved with a guard check: `if result.stdout and ("CRITICAL" in result.stdout or "HIGH" in result.stdout)`.

7. **Duplicate "No vulnerabilities" prints**: The no-vulnerability print statement was inside the container loop, printing once per container instead of once per pod. Moved to the pod-level `else` block.

8. **`python-dotenv` not installed by default**: `notifier.py` threw `ModuleNotFoundError: No module named 'dotenv'` on first run. Resolved with `pip install python-dotenv`.

---

## Cleanup

**Stop the cluster (preserves state):**
```bash
minikube stop
```

**Resume later:**
```bash
minikube start
```

**Remove quarantine labels from all pods:**
```bash
kubectl label pods --all quarantine-
```

**Delete Istio AuthorizationPolicy:**
```bash
kubectl delete authorizationpolicy deny-quarantine
```

**Full cluster teardown:**
```bash
minikube delete
```

---

## Lessons Learned

1. **CNI Matters**: Not all Kubernetes distributions enforce NetworkPolicies — always verify your CNI plugin (e.g., Calico, Cilium) before relying on NetworkPolicies for security controls
2. **Service Mesh as a Security Layer**: Istio AuthorizationPolicy provides reliable, sidecar-enforced traffic control independent of the underlying CNI
3. **mTLS Requires Ingress Planning**: Enabling strict mTLS without configuring a proper ingress path breaks external access — Gateway + VirtualService must be set up first
4. **Windows Encoding**: Always specify `encoding="utf-8"` in Python subprocess calls on Windows when parsing CLI tool output
5. **Idempotent Scripts**: Automation scripts must handle "already exists" states gracefully — one-time API calls will fail on re-runs without proper error handling
6. **Secret Hygiene**: Never hardcode credentials — use `.env` files with `python-dotenv` and always add them to `.gitignore` before first commit

---

## Skills Demonstrated

- Kubernetes cluster administration and application deployment
- Istio service mesh configuration (Gateway, VirtualService, PeerAuthentication, AuthorizationPolicy)
- Mutual TLS (mTLS) enforcement across microservices
- Zero Trust network segmentation with Kubernetes NetworkPolicies
- Container image vulnerability scanning with Trivy
- Python automation with the Kubernetes client library
- Automated incident response pipeline (detect → quarantine → isolate → alert)
- Gmail SMTP integration for real-time alerting
- Secure secret management (python-dotenv, .gitignore)
- Debugging and troubleshooting in a Windows/Minikube environment
- Technical documentation

---

## Notes

- This lab uses the Google Kubernetes Engine Guestbook application, which uses intentionally outdated images. Due to this, it is not possible to demonstrate new containers spinning up to replace quarantined ones with patched images as would happen in a production environment.
- All workloads run entirely locally via Minikube — no cloud provider account is required.
- The automation scheduler (`auto_detect_and_quarantine.py`) will quarantine all Guestbook pods on every run due to the `:latest` image tags and known CVEs in the demo images. This is expected behavior for this lab.

---

## References

- [Minikube Documentation](https://minikube.sigs.k8s.io/docs/)
- [Istio Documentation](https://istio.io/latest/docs/)
- [Istio AuthorizationPolicy](https://istio.io/latest/docs/reference/config/security/authorization-policy/)
- [Istio PeerAuthentication (mTLS)](https://istio.io/latest/docs/reference/config/security/peer_authentication/)
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)
- [Kubernetes NetworkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- [Kubernetes Python Client](https://github.com/kubernetes-client/python)
- [python-dotenv](https://pypi.org/project/python-dotenv/)

---

## Author

**John** - Aspiring Cloud Security Engineer/Architect  
*Completing Master's degree and building portfolio for cloud security roles*

---

**Date Completed**: March 7, 2026  
**Project Type**: Security DevOps Lab  
**Purpose**: Portfolio demonstration for cloud security engineering positions
