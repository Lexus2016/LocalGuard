# LocalGuard

Transparent HTTP proxy that redacts secrets and PII before they reach LLM providers. Your API keys, passwords, credit cards, and personal data never leave your machine.

## What it does

```
Your app  -->  LocalGuard  -->  LLM API (OpenAI, Anthropic, etc.)
                   |
            secrets removed
            before sending
```

LocalGuard sits between your application and the LLM API. It automatically detects and redacts 32+ types of sensitive data (API keys, passwords, emails, credit cards, names, addresses) and restores them in responses. Zero code changes required.

## Install

**macOS / Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/Lexus2016/LocalGuard/main/install.sh | sh
```

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/Lexus2016/LocalGuard/main/install.ps1 | iex
```

## Quick Start

### 1. Start the proxy

```bash
llm-security-proxy start
```

On first run, LocalGuard will ask which LLM providers you use and create a config file automatically.

### 2. Get a license

Purchase at [llm-proxy.gumroad.com](https://llm-proxy.gumroad.com) and activate:

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

| Provider | Local port | Upstream |
|----------|-----------|----------|
| OpenAI | 4010 | api.openai.com |
| Anthropic | 4020 | api.anthropic.com |
| Ollama | 4050 | localhost:11434 |
| Google Gemini | 4060 | generativelanguage.googleapis.com |
| xAI | 4070 | api.x.ai |

More providers can be added in `~/.llm-proxy/config.yaml`.

## What gets redacted

| Category | Examples |
|----------|----------|
| API keys | OpenAI, Anthropic, AWS, GitHub, Stripe, Slack, SendGrid |
| Passwords | In plaintext, URLs, config files |
| Credit cards | Visa, Mastercard, Amex (Luhn-validated) |
| Emails & phones | RFC 5322 emails, international phone numbers |
| Tokens | JWT, Bearer tokens |
| Financial | IBAN, crypto addresses (Bitcoin, Ethereum) |
| Crypto keys | PEM private keys (RSA, EC, ED25519) |
| Personal names | Via contextual AI analysis (optional Stage 2) |
| Locations | Cities, countries, addresses (optional Stage 2) |

## License Tiers

| Tier | Price | Bind address | Use case |
|------|-------|-------------|----------|
| Pro | $49/year | localhost only | Single developer |
| Team | $99/year | Any interface | Shared proxy for a team |

## Commands

```bash
llm-security-proxy start          # Start the proxy
llm-security-proxy activate       # Activate license
llm-security-proxy license        # Show license status
llm-security-proxy update         # Update to latest version
llm-security-proxy stats          # Show statistics
llm-security-proxy check-config   # Validate config file
```

## FAQ

**Lost your license key?**
Run `llm-security-proxy activate` again with the same Gumroad key. It will restore your license.

**Lost your Gumroad key?**
Go to [gumroad.com](https://gumroad.com), click "I lost my license", enter your email.

**Changed your computer?**
A new machine requires a new license purchase. Each license is tied to one computer.

**How to update?**
```bash
llm-security-proxy update
```

## License

MIT
