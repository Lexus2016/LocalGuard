# LocalGuard

**[localguard.me](https://localguard.me)** — Transparent HTTP proxy that redacts secrets and PII before they reach LLM providers. Your API keys, passwords, credit cards, and personal data never leave your machine.

## What it does

```
Your app  -->  LocalGuard  -->  LLM API (OpenAI, Anthropic, etc.)
                   |
            secrets removed
            before sending
```

LocalGuard sits between your application and the LLM API. It automatically detects and redacts 32+ types of sensitive data (API keys, passwords, emails, credit cards, names, addresses) and restores them in responses. Zero code changes required.

## Install

### Desktop App (GUI)

Download the desktop app for your platform:

| Platform | Download |
|----------|----------|
| macOS (Apple Silicon) | [LocalGuard.dmg](https://github.com/Lexus2016/LocalGuard/releases/latest) |
| macOS (Intel) | [LocalGuard.dmg](https://github.com/Lexus2016/LocalGuard/releases/latest) |
| Windows | [LocalGuard.msi](https://github.com/Lexus2016/LocalGuard/releases/latest) |
| Linux | [LocalGuard.AppImage](https://github.com/Lexus2016/LocalGuard/releases/latest) / [.deb](https://github.com/Lexus2016/LocalGuard/releases/latest) |

### CLI (Command Line)

**macOS / Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/Lexus2016/LocalGuard/main/install.sh | sh
```

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/Lexus2016/LocalGuard/main/install.ps1 | iex
```

The installer downloads the binary **and** the NER model (~200MB total). Everything works out of the box after installation.

### Manual install

Download the archive for your platform from [Releases](https://github.com/Lexus2016/LocalGuard/releases/latest), extract it, and place the binary in your PATH.

**macOS (Apple Silicon):**
```bash
tar xzf llm-security-proxy-*-aarch64-apple-darwin.tar.gz
sudo mv llm-security-proxy /usr/local/bin/
```

**macOS (Intel):**
```bash
tar xzf llm-security-proxy-*-x86_64-apple-darwin.tar.gz
sudo mv llm-security-proxy /usr/local/bin/
```

**Linux (x86_64):**
```bash
tar xzf llm-security-proxy-*-x86_64-unknown-linux-gnu.tar.gz
sudo mv llm-security-proxy /usr/local/bin/
```

**Linux (ARM64):**
```bash
tar xzf llm-security-proxy-*-aarch64-unknown-linux-gnu.tar.gz
sudo mv llm-security-proxy /usr/local/bin/
```

**Windows:**
1. Download `llm-security-proxy-*-x86_64-pc-windows-msvc.tar.gz`
2. Extract and add the folder to your PATH

## Quick Start

### 1. Run interactive setup

```bash
llm-security-proxy setup
```

The setup wizard will ask which LLM providers you use and create a config file automatically.

### 2. Get a license (optional)

Free mode works with regex-only scanning. For full AI-powered detection (names, addresses, contextual secrets), subscribe at **[localguard.me](https://localguard.me/buy)**:

```bash
llm-security-proxy activate
```

Paste your license key when prompted. Done.

### 3. Point your app to localhost

Instead of `https://api.openai.com`, use `http://localhost:4010`. That's it.

```bash
# Example: OpenAI through LocalGuard
curl http://localhost:4010/v1/chat/completions \
  -H "Authorization: Bearer sk-..." \
  -H "Content-Type: application/json" \
  -d '{"model":"gpt-4","messages":[{"role":"user","content":"Hello"}]}'
```

## Supported Providers

### Pre-configured providers

| Provider | Default Port | Upstream |
|----------|-------------|----------|
| OpenAI | 4010 | api.openai.com |
| Anthropic | 4020 | api.anthropic.com |
| Google Gemini | 4030 | generativelanguage.googleapis.com |
| Mistral | 4040 | api.mistral.ai |
| Ollama | 4050 | localhost:11434 |
| Google Vertex AI | 4060 | us-central1-aiplatform.googleapis.com |
| xAI (Grok) | 4070 | api.x.ai |
| Cohere | 4080 | api.cohere.com |
| DeepSeek | 4090 | api.deepseek.com |
| Groq | 4100 | api.groq.com |
| Together AI | 4110 | api.together.xyz |
| Fireworks AI | 4120 | api.fireworks.ai |
| Perplexity | 4130 | api.perplexity.ai |
| AI21 Labs | 4140 | api.ai21.com |
| Replicate | 4150 | api.replicate.com |
| Hugging Face | 4160 | api-inference.huggingface.co |
| AWS Bedrock | 4170 | bedrock-runtime.us-east-1.amazonaws.com |
| Azure OpenAI | 4180 | *.openai.azure.com |
| Databricks | 4190 | *.cloud.databricks.com |
| Anyscale | 4200 | api.endpoints.anyscale.com |
| OpenRouter | 4210 | openrouter.ai |
| LM Studio | 4220 | localhost:1234 |
| Jan AI | 4230 | localhost:1337 |
| text-generation-webui | 4240 | localhost:5000 |
| vLLM | 4250 | localhost:8000 |
| LocalAI | 4260 | localhost:8080 |

### Custom / self-hosted providers

Any OpenAI-compatible API can be proxied. Add to `~/.llm-proxy/config.yaml`:

```yaml
providers:
  - name: my-custom-llm
    listen_port: 4300
    upstream: "https://my-llm-server.internal:8443"
    path_prefix: "/v1"
```

## What gets redacted

| Category | Examples |
|----------|----------|
| API keys | OpenAI, Anthropic, AWS, GitHub, Stripe, Slack, SendGrid, Shopify |
| Passwords | In plaintext, URLs, config files |
| Credit cards | Visa, Mastercard, Amex (Luhn-validated) |
| Emails & phones | RFC 5322 emails, international phone numbers |
| Tokens | JWT, Bearer tokens |
| Financial | IBAN, crypto addresses (Bitcoin, Ethereum) |
| Crypto keys | PEM private keys (RSA, EC, ED25519) |
| Personal names | Via contextual AI analysis (NER Stage 2) |
| Locations | Cities, countries, addresses (NER Stage 2) |

## Pricing

| | Free | Personal |
|------|------|---------|
| Price | $0 | $39/year |
| Regex scanning | Yes | Yes |
| AI-powered NER | No | Yes |
| Name/address detection | No | Yes |
| Bind address | localhost | localhost |
| Support | Community | Email |

Subscribe at **[localguard.me](https://localguard.me/buy)**.

## Commands

```bash
llm-security-proxy setup            # Interactive setup wizard
llm-security-proxy start            # Start the proxy
llm-security-proxy activate         # Activate license
llm-security-proxy license          # Show license status
llm-security-proxy update           # Update to latest version
llm-security-proxy stats            # Show statistics
llm-security-proxy check-config     # Validate config file
```

## Performance

- NER inference: 20-40ms per message (Apple Silicon)
- Regex scanning: <1ms
- Memory: ~400MB RSS with NER model loaded
- Tested with 100 concurrent agents at 0 errors

## FAQ

**Can I use LocalGuard for free?**
Yes. Free mode provides regex-only scanning (API keys, passwords, credit cards, emails, etc.). Subscribe for AI-powered detection of names, addresses, and contextual secrets.

**How to update?**
Desktop app updates automatically. CLI:
```bash
llm-security-proxy update
```

**Changed your computer?**
Each license is tied to one machine fingerprint. Contact support to transfer.

**Manage your subscription?**
Visit the customer portal via the GUI or at [localguard.me](https://localguard.me).

## License

MIT
