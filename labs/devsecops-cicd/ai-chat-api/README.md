# .NET Chat API with OpenAI

An ASP.NET Core Web API that accepts a user prompt and returns a real-time AI response. Built with .NET 9 minimal APIs and the OpenAI SDK (gpt-4o-mini).

---

## What It Does

`POST /chat` — send a plain text prompt, get an AI-generated response back.

```
Request:  { "prompt": "Explain Zero Trust in one sentence" }
Response: "Zero Trust is a security model that assumes no person or device,
           whether inside or outside the network, can be trusted by default
           and requires continuous verification of identity and access permissions."
```

---

## Tech Stack

- **Runtime:** .NET 9 / ASP.NET Core (Minimal APIs)
- **Language:** C#
- **AI:** OpenAI API — gpt-4o-mini
- **Config:** ASP.NET `IConfiguration` / `appsettings.json`

---

## Project Structure

```
AIChatAPI/
├── Program.cs              # All API logic — single-file minimal API
├── appsettings.json        # Config (excluded from git — contains API key)
├── appsettings.example.json
├── AIChatAPI.csproj
└── .gitignore
```

---

## How to Run Locally

### Prerequisites
- [.NET 9 SDK](https://dotnet.microsoft.com/download)
- An OpenAI API key from [platform.openai.com/api-keys](https://platform.openai.com/api-keys) (requires billing credits)

### 1. Clone and enter the project

```bash
git clone <your-repo-url>
cd AIChatAPI
```

### 2. Configure your API key

Copy the example config and fill in your key:

```bash
copy appsettings.example.json appsettings.json
```

`appsettings.json`:
```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*",
  "OpenAI": {
    "ApiKey": "your-openai-api-key-here"
  }
}
```

### 3. Run it

```bash
dotnet run
```

The API starts on `http://localhost:5249`.

### 4. Test it

On Windows PowerShell:

```powershell
Invoke-WebRequest -Uri "http://localhost:5249/chat" `
  -Method POST `
  -ContentType "application/json" `
  -Body '{"prompt": "Explain Zero Trust in one sentence"}'
```

> **Note:** PowerShell maps `curl` to `Invoke-WebRequest` with different syntax. If you get a "parameter cannot be found" error using `curl -X`, switch to `Invoke-WebRequest` as shown above.

On Linux/Mac/Git Bash:

```bash
curl -X POST http://localhost:5249/chat \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Explain Zero Trust in one sentence"}'
```

---

## Core Code

`Program.cs` is a single-file minimal API — no controllers, no boilerplate:

```csharp
using OpenAI;
using OpenAI.Chat;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

var apiKey = builder.Configuration["OpenAI:ApiKey"];
var client = new ChatClient("gpt-4o-mini", apiKey);

app.MapPost("/chat", async (ChatRequest req) =>
{
    var response = await client.CompleteChatAsync(req.Prompt);
    return response.Value.Content[0].Text;
});

app.Run();

record ChatRequest(string Prompt);
```

Credentials are read from `appsettings.json` via `IConfiguration` — never hardcoded.

---

## Build Log — Issues Hit and How They Were Resolved

This section documents the real troubleshooting that happened during this build.

---

### Issue 1: Azure OpenAI model deployment — gpt-35-turbo deprecated

**What happened:** Created an Azure OpenAI resource and tried to deploy `gpt-35-turbo`.

**Error:**
```
ServiceModelDeprecated: The model 'gpt-35-turbo' has been deprecated since 11/14/2025
```

**Fix:** Attempted to deploy `gpt-4o-mini` instead.

---

### Issue 2: Azure OpenAI quota — InvalidCapacity

**What happened:** Tried deploying `gpt-4o-mini` in East US, then East US 2.

**Error:**
```
InvalidCapacity: The specified capacity '0' of account deployment should be at least 1
```

The token rate limit slider in Azure OpenAI Studio couldn't be moved — locked at 0.

**Root cause:** Azure OpenAI requires a separate approval process for access. New Azure subscriptions don't have quota automatically. Checking Azure Portal → Quotas → filtering by provider showed no OpenAI entries at all, confirming the subscription hadn't been approved.

**Fix:** Pivoted away from Azure OpenAI entirely. Switched to the standard OpenAI API (`platform.openai.com`) which doesn't require any approval process, just a billing-enabled account.

> The package `Azure.AI.OpenAI` was already installed and it pulls in the `OpenAI` SDK as a dependency — so the `OpenAI` and `OpenAI.Chat` namespaces were already available without installing an additional package.

---

### Issue 3: Wrong code after switching from Azure SDK to OpenAI SDK

**What happened:** After deciding to use the OpenAI SDK instead of Azure, the initial rewrite still used Azure-specific classes.

**Broken code:**
```csharp
using OpenAI;
using OpenAI.Chat;

var builder = WebApplication.CreateBuilder(args);
var app = builder.build();                             // lowercase b

app.MapPost("/chat", async (chatRequest req) =>        // lowercase c
{
    var client = new OpenAIClient(                     // Azure class, wrong package
        new AzureKeyCredential(builder.Configuration["OpenAI:ApiKey"])
    );

    var options = new ChatCompletionsOptions()         // Azure class, wrong package
    {
        DeploymentName = "gpt-4",
        Messages = { new ChatRequestUserMessage(req.Prompt) }
    };

    var response = await client.GetChatCompletionsAsunc(options);  // typo + wrong method
    return response.Value.Choices[0].Message.Content;
});

app.Run();

record ChatRequest(string Prompt):    // colon instead of semicolon
```

**Bugs in that version:**
| Bug | Why it breaks |
|-----|---------------|
| `builder.build()` | C# is case-sensitive — must be `builder.Build()` |
| `chatRequest req` | Must be `ChatRequest` — type names are case-sensitive |
| `OpenAIClient`, `AzureKeyCredential`, `ChatCompletionsOptions` | These are Azure SDK classes, wrong package after switching |
| `GetChatCompletionsAsunc` | Typo, and also the wrong method entirely for the OpenAI SDK |
| `record ChatRequest(string Prompt):` | Colon instead of semicolon terminates the record incorrectly |

**Fix:** Rewrote using the correct OpenAI SDK classes — `ChatClient` and `CompleteChatAsync`.

---

### Issue 4: curl doesn't work in Windows PowerShell

**What happened:** Tried to test the API with the standard curl command.

**Command run:**
```
curl -X POST http://localhost:5249/chat ...
```

**Error:**
```
Invoke-WebRequest : A parameter cannot be found that matches parameter name 'X'.
```

**Root cause:** PowerShell maps `curl` to its own `Invoke-WebRequest` cmdlet, which uses completely different syntax. The `-X` flag doesn't exist in `Invoke-WebRequest`.

**Fix:** Use `Invoke-WebRequest` with PowerShell-native syntax:
```powershell
Invoke-WebRequest -Uri "http://localhost:5249/chat" -Method POST -ContentType "application/json" -Body '{"prompt": "..."}'
```

---

### Issue 5: HTTP 500 — OpenAI quota exceeded

**What happened:** `Invoke-WebRequest` returned a 500 error. Checked the `dotnet run` terminal for the actual exception.

**Server log:**
```
System.ClientModel.ClientResultException: HTTP 429 (insufficient_quota: insufficient_quota)
You exceeded your current quota, please check your plan and billing details.
```

**Root cause:** New OpenAI API accounts have no credits by default. The API key was valid, the code was correct — the account just had a $0 balance.

**Fix:** Added a credit balance at [platform.openai.com/settings/billing](https://platform.openai.com/settings/billing). Re-ran the test, got a 200 OK response.

---

### Issue 6: PowerShell security prompt on Invoke-WebRequest

**What happened:** After adding credits, ran `Invoke-WebRequest` again and got an interactive warning:

```
Security Warning: Script Execution Risk
Invoke-WebRequest parses the content of the web page. Script code in the web
page might be run when the page is parsed.
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend
```

**Fix:** Type `Y` and hit Enter. This is a standard PowerShell warning for any web response — not a real security risk for a localhost test.

---

## Credential Security

- `appsettings.json` is in `.gitignore` — the API key never gets committed
- `appsettings.example.json` is committed with placeholder values so other developers know the expected format
- For production, replace `IConfiguration` key reading with `DefaultAzureCredential` (managed identity) — no keys needed at all

---

## Build Progression — Full Walkthrough in Screenshots

Every step, mistake, and fix captured in order.

---

### Step 1 — Project Scaffold

**01 — `dotnet new webapi` succeeds**
![01](AI%20API%20Lab/01.png)
Terminal confirms the ASP.NET Core Web API template was created successfully under `AIChatAPI/`.

---

**02 — Project structure opens in VS Code**
![02](AI%20API%20Lab/02.png)
VS Code Explorer shows the freshly scaffolded project — `Program.cs`, `appsettings.json`, `.csproj`, and the `Properties/` folder all generated automatically.

---

**03 — Installing the Azure OpenAI NuGet package**
![03](AI%20API%20Lab/03.png)
`dotnet add package Azure.AI.OpenAI` runs — NuGet downloads the SDK and its dependencies. This package also bundles the standard `OpenAI` SDK, which becomes important later.

---

**04 — Default boilerplate `Program.cs`**
![04](AI%20API%20Lab/04.png)
The scaffolded `Program.cs` with the default `WeatherForecast` endpoint — this gets cleared before writing the actual chat API code.

---

### Step 2 — Writing the Code

**05 — `Program.cs` wiped, ready to write**
![05](AI%20API%20Lab/05.png)
`Program.cs` cleared out. Starting from a blank file to write the `/chat` endpoint from scratch.

---

**06 — First version of `Program.cs` — broken**
![06](AI%20API%20Lab/06.png)
First attempt at the endpoint code. Contains multiple bugs: `builder.build()` (lowercase), `chatRequest` (lowercase type name), still using Azure SDK classes (`OpenAIClient`, `AzureKeyCredential`, `ChatCompletionsOptions`), a typo in the method name (`GetChatCompletionsAsunc`), and a colon instead of a semicolon on the `record` declaration.

---

**07 — `appsettings.json` updated with Azure config block**
![07](AI%20API%20Lab/07.png)
`AzureOpenAI` section added to `appsettings.json` with `Endpoint` and `ApiKey` fields. Credentials read via `IConfiguration` — not hardcoded.

---

### Step 3 — Azure OpenAI Setup (and why it didn't work)

**08 — Azure Portal — Create Azure OpenAI resource: Basics tab**
![08](AI%20API%20Lab/08.png)
Azure Portal "Create Azure OpenAI" form. Resource group `ai-chat-api-rg`, region East US, name `ai-chat-api-openai`, pricing tier Standard S0.

---

**09 — Azure Portal — Networking tab**
![09](AI%20API%20Lab/09.png)
Network access set to "All networks" — appropriate for a dev/lab resource.

---

**10 — Azure Portal — Review + Submit**
![10](AI%20API%20Lab/10.png)
Final configuration review before deploying the Azure OpenAI resource.

---

**11 — VS Code — Build errors on the broken code**
![11](AI%20API%20Lab/11.png)
VS Code surfaces compiler errors from the first `Program.cs` attempt — squiggly underlines on `AzureKeyCredential` and other Azure SDK classes confirming the wrong namespace is being used.

---

**12 — `.gitignore` updated to exclude `appsettings.json`**
![12](AI%20API%20Lab/12.png)
`echo "appsettings.json" >> .gitignore` run in terminal — ensures the API key never gets committed to GitHub.

---

**13 — `appsettings.example.json` created**
![13](AI%20API%20Lab/13.png)
Example config file committed with placeholder values so anyone cloning the repo knows the exact structure needed without exposing a real key.

---

**14 — `dotnet run` fails — build errors from the broken code**
![14](AI%20API%20Lab/14.png)
Terminal shows `error CS1031`, `CS1514`, `CS1513` — the build crashes from the colon-instead-of-semicolon bug and other syntax errors in the first code version.

---

**15 — Azure OpenAI resource deployed in Foundry**
![15](AI%20API%20Lab/15.png)
Microsoft Foundry confirms `ai-chat-api-openai` is provisioned in East US, Standard S0. Resource is live — but no models deployed yet.

---

**16 — Model deployments page — empty**
![16](AI%20API%20Lab/16.png)
Azure OpenAI Studio deployments page showing "No deployments to display." Need to deploy a model before the API can call anything.

---

**17 — First model attempt: `gpt-35-turbo` — deprecated**
![17](AI%20API%20Lab/17.png)
Selected `gpt-35-turbo` in the model catalog. Deployment fails immediately: `ServiceModelDeprecated — the model has been deprecated since 11/14/2025`.

---

**18 — Second model attempt: `gpt-4o-mini` — quota locked at 0**
![18](AI%20API%20Lab/18.png)
Switched to `gpt-4o-mini`. Deployment fails with `InvalidCapacity: The specified capacity '0'` — the token rate limit slider is locked and can't be changed. Azure subscription hasn't been approved for OpenAI quota.

---

**19 — Third attempt: `gpt-35-turbo-16k` — same result**
![19](AI%20API%20Lab/19.png)
Tried `gpt-35-turbo-16k` as an alternative. Hit the same capacity error — confirms this is a subscription-level quota issue, not model-specific.

---

**20 — Trying `gpt-4o-mini` in a different region**
![20](AI%20API%20Lab/20.png)
Attempted redeploying `gpt-4o-mini` after switching the resource region. Same `InvalidCapacity: 0` error. Azure OpenAI quota is not available on this subscription regardless of region — a separate approval is required via `aka.ms/oai/access`.

---

### Step 4 — Pivot to OpenAI API

**21 — platform.openai.com — generating an API key**
![21](AI%20API%20Lab/21.png)
Azure OpenAI blocked by quota approval process. Pivoted to the standard OpenAI API — no approval needed, just a billing-enabled account. Creating a new secret key with "All" permissions.

---

**22 — `appsettings.example.json` updated for OpenAI**
![22](AI%20API%20Lab/22.png)
Config restructured — Azure `Endpoint` removed, replaced with a single `OpenAI: { ApiKey }` block. Much simpler since the standard OpenAI SDK doesn't need an endpoint URL.

---

**23 — Final correct `Program.cs`**
![23](AI%20API%20Lab/23.png)
Clean rewrite using the correct OpenAI SDK classes: `using OpenAI`, `using OpenAI.Chat`, `ChatClient("gpt-4o-mini", apiKey)`, `CompleteChatAsync`, and `record ChatRequest(string Prompt);` with the correct semicolon.

---

### Step 5 — Testing

**24 — VS Code split view: code + first successful `dotnet run`**
![24](AI%20API%20Lab/24.png)
Final `Program.cs` visible alongside the terminal. After the previous build failures, `dotnet run` now succeeds — "Now listening on: http://localhost:5249".

---

**25 — API running on localhost:5249**
![25](AI%20API%20Lab/25.png)
Clean `dotnet run` output — application started, listening on `http://localhost:5249`, hosting environment: Development.

---

**26 — First POST request — HTTP 500**
![26](AI%20API%20Lab/26.png)
`Invoke-WebRequest` POST to `/chat` returns a 500 Internal Server Error. Code is correct — something is failing inside the handler. Checked the server terminal to find the actual exception.

---

**27 — Server log: HTTP 429 insufficient_quota**
![27](AI%20API%20Lab/27.png)
`dotnet run` terminal reveals the real error: `System.ClientModel.ClientResultException: HTTP 429 — insufficient_quota`. The API key is valid and the code works — but the OpenAI account has a $0 balance and no active credits.

---

**28 — OpenAI billing — $5 credit added**
![28](AI%20API%20Lab/28.png)
platform.openai.com billing page confirms $5.00 credit balance added, "Pay as you go" plan active. This unblocks the API calls.

[← Back to Main Portfolio](../../README.md)
---

**29 — HTTP 200 — it works**
![29](AI%20API%20Lab/29.png)
`Invoke-WebRequest` returns 200 OK. Response content: *"Zero Trust is a security model that assumes no person or device, whether inside or outside the network, can be trusted by default and requires continuous verification of identity and access permissions..."* — the API is fully working end to end.

---

