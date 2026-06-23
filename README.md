# LocalGuard

> Protect your secrets from AI agents

**LocalGuard** — a local proxy that redacts confidential data before sending it to LLM providers. Works with any AI agents: Claude Code, ChatGPT, Codex CLI, Aider, and others.

## What it does

- **Intercepts** API keys, tokens, passwords, PII, crypto wallets, PEM keys
- **Runs 100% locally** — no data leaves your machine
- **Adds <50ms latency** per request
- **Supports** macOS, Linux, Windows

## Pricing

| Plan | Price | What's included |
|------|-------|---------------|
| **Free** | $0 | API keys, Bearer/JWT tokens, AWS/GitHub keys, PEM, crypto wallets, IBAN |
| **Pro** | $39/year (~$3.25/mo) | Free + credit cards, email, phones, passwords, PII, real-time dashboard |
| **Enterprise** | Contact us | Pro + 2 server licenses, extended detection rules, AI tuning, priority support |

## Install

### Desktop app

- **macOS** — `brew install --cask localguard`
- Or download from [Releases](https://github.com/Lexus2016/LocalGuard/releases): `.dmg` (macOS) · `.AppImage` / `.deb` (Linux) · `.exe` (Windows)

### CLI / console proxy

One-line install (macOS arm64 · Linux x86_64 / arm64):

```bash
curl -fsSL https://raw.githubusercontent.com/Lexus2016/LocalGuard/main/install.sh | sh
```

Or via Homebrew:

```bash
brew tap lexus2016/tap https://github.com/Lexus2016/homebrew-tap
brew install localguard
```

This installs the `localguard` command (the legacy name `llm-security-proxy` also works).

## Run your AI tools through the proxy

Start the proxy, then launch a client pre-configured to route through it. Secrets in
requests are redacted before they reach the provider and restored in the response:

```bash
localguard start                 # start the local proxy daemon
localguard status                # check it's running

localguard launch opencode       # OpenCode
localguard launch claude-code    # Claude Code (Anthropic)
localguard launch codex          # Codex CLI
localguard launch aider          # aider (OpenAI + Anthropic)
localguard launch gemini-cli     # Gemini CLI
```

Supported clients: `claude-code`, `aider`, `goose`, `qwen-code`, `gemini-cli`, `opencode`, `zed`, `sgpt`, `codex`.

Narrow a multi-provider client to a single upstream, or forward extra arguments to the
client after `--`:

```bash
localguard launch aider --provider anthropic
localguard launch claude-code -- --model claude-sonnet-4-6
```

`launch` starts the daemon if it isn't running, points the client's base URL at the
local proxy, and uses your existing provider API key as-is — it does not manage or store
keys, so the client must already be authenticated. Clients with hardcoded endpoints
(Cursor, Windsurf) are not supported.

## Quick Start

1. Install LocalGuard
2. Activate your license
3. Select detection mode: Full / Regex Only / Off
4. Configure your AI agents (Claude Code, Codex CLI, etc.)
5. Monitor Dashboard and Logs

Detailed guide: [localguard.me/guide](https://localguard.me/guide)

## Contact

- **Email:** [support@localguard.me](mailto:support@localguard.me)
- **Website:** [localguard.me](https://localguard.me)
- **GitHub:** [Lexus2016/LocalGuard](https://github.com/Lexus2016/LocalGuard)

---

© 2026 LocalGuard. All rights reserved.
