# Architecture

## High-level flow

```
User (chat)
  → n8n Chat Trigger
  → AI Agent (LangChain)
       ├── Google Gemini Chat Model  (gemini-1.5-flash, temperature 0.2)
       ├── Window Buffer Memory      (10-message window, keyed by session ID)
       ├── Tavily Web Search         (HTTP tool, POST to tavily.com/search)
       └── Open-Meteo Bangkok Weather (HTTP tool)
  ← Response
```

## Design choices

### Why Gemini 1.5 Flash?

- Free tier is generous (15 RPM, 1M TPM, 1500 RPD — enough for a portfolio demo and small-scale testing).
- 1M context window signals "modern frontier model".
- Strong tool-use support via the LangChain integration in n8n.
- Trivial to swap for Claude or GPT later.

### Why n8n over raw Python?

The Sertis JD emphasizes *productionization*, not *model novelty*. n8n demonstrates:

- **Visual orchestration** — recruiters can see the structure at a glance, no need to read 200 lines of Python.
- **Built-in error handling, retries, logging** — production concerns handled by the platform.
- **Hosted on n8n Cloud** = deployed agent, not a notebook.
- **Webhook / chat trigger** = production entry point.

The agent code (system prompt + tool descriptions) is what's actually interesting. n8n just hosts it.

### Why these two tools?

- **Tavily** — AI-native web search built specifically for LLM agents. Returns clean snippets with source URLs and a synthesized answer, not raw HTML. Free tier covers 1,000 searches/month — plenty for demos. Picked over Wikipedia because live data > encyclopedia data for business research.
- **Open-Meteo Bangkok Weather** — free, no auth, real data, thematically maps to Sertis's **energy** and **retail** verticals (weather drives energy demand and foot traffic).

Tavily requires an API key; weather does not. For portfolio simplicity, the key sits in the request body of the tool node (Tavily's native auth style) rather than a separate n8n credential — one fewer moving part during setup. See *Customizing* in the README for how to move it to a credential later.

### Why temperature 0.2?

Business research wants consistency over creativity. 0.2 keeps the agent's structure predictable across runs — important when you want demos to look the same. Crank it for brainstorming modes.

### Why 10-message memory?

Enough to handle multi-turn conversations ("what about last year?" / "for Bangkok specifically?") without blowing context. Bigger windows = slower + more expensive.

## Data flow on a single query

1. User types query into the n8n Chat panel.
2. **Chat Trigger** fires, emits `{ chatInput, sessionId }`.
3. **AI Agent** receives the message, asks Gemini: *"Here's the conversation + these tools — what do you want to call?"*
4. Gemini returns a tool-call plan (e.g., `tavily_web_search(query="CP Group retail 2026")` + `open_meteo_bangkok_weather()`).
5. n8n executes the HTTP tool calls, returns results to Gemini.
6. Gemini synthesizes a structured answer.
7. **AI Agent** outputs the final text → Chat panel displays it.

Every step is visible in n8n's **Execution** log — great for demos and debugging.

## Failure modes and handling

| Failure | Handling |
|---|---|
| Tool returns 404 / no data | Prompt instructs Gemini to acknowledge it, not fabricate |
| Tool times out (>10s) | HTTP Request Tool fails; agent retries once or returns error to user. Logged in n8n Cloud. |
| Gemini rate-limited | n8n queues subsequent calls; user sees a "thinking…" state. Unlikely in normal use on the free tier. |
| Out-of-scope question | Prompt instructs the agent to say so rather than guess. |
| Malicious input | n8n Cloud provides basic auth + rate limiting; further hardening is on the roadmap. |

## What this would look like in production at Sertis

- Replace n8n Chat with a **client-facing Slack/Teams webhook** as the entry point.
- Add a **Postgres logging node** to capture queries + answers for evaluation and audit.
- Add an **Output Parser node** to enforce a JSON schema for downstream CRM ingestion.
- Replace Gemini with the client's preferred LLM (or **Sertis PrivateLLM**) — single node swap.
- Add an **eval flow** triggered on PR that compares agent outputs to a golden set.
- Deploy via n8n's **self-hosted runner** on the client's AWS/GCP account.

## Why this design is hireable

A reviewer reading this repo will see:

1. **A real problem framing** — not a toy "ask the LLM a question" demo.
2. **Tool-use reasoning** — the agent plans, not just retrieves.
3. **Production thinking** — error paths, memory, hosted deployment.
4. **Documentation discipline** — code, prompts, architecture, and demo are all in the repo.
5. **Domain awareness** — every tool maps to a Sertis vertical.

That's the whole point of a portfolio piece.