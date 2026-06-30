# Agentic Business Research Assistant

A multi-tool AI agent built in **n8n** that turns a free-text business question into a structured, tool-grounded answer. Demonstrates **agentic systems, tool use, and orchestration** — built as a portfolio piece for AI/ML engineer internship applications at companies like Sertis.

> **Live demo:** _add link after deploy_ · **Video walkthrough:** _add link after recording_ · **Stack:** n8n Cloud · Google Gemini 1.5 Flash · Tavily · Open-Meteo

---

## What it does

Ask a business question in plain language. The agent decides which tools to call, gathers the data, and returns a structured answer.

**Example queries** (see [`docs/demo-script.md`](docs/demo-script.md) for the full walkthrough):

- "Give me background on Charoen Pokphand Group and how their retail division might be affected by Bangkok's weather this week."
- "Brief me on Siam Commercial Bank for a client meeting tomorrow."
- "What's the stock price of PTT today?" _(expected: honest refusal, no fabrication)_

Each query can trigger one or two tool calls; the agent decides which, when, and in what order.

## Why this project

Targets skills called out in the **Sertis AI/ML Engineer Intern JD**:

| JD requirement | Where it's shown |
|---|---|
| *"Agentic systems from scratch"* | The whole project — agent plans, picks tools, reasons over results |
| *"Production-grade software for model inference"* | n8n workflow with error handling, structured I/O, memory, idempotent re-runs |
| *"Generative AI concepts and LLM APIs"* | Google Gemini integration via n8n's LangChain nodes, prompt engineering |
| *"Cloud-native APIs, pipelines"* | Triggered via n8n Cloud's hosted chat endpoint; HTTP-based tools |
| *"Technical documentation"* | This README, architecture doc, prompt doc, demo script |

## Architecture

```
┌─────────────────┐
│  Chat Trigger   │  ← user sends message
└────────┬────────┘
         ▼
┌─────────────────┐
│   AI Agent      │  ← plans, decides tools, synthesizes
│  (LangChain)    │
└────────┬────────┘
         │ uses
         ├──────► Google Gemini Chat Model   (gemini-1.5-flash)
         ├──────► Window Buffer Memory       (10-message context)
         ├──────► Tavily Web Search          (HTTP tool)
         └──────► Open-Meteo Bangkok Weather (HTTP tool)
```

See [`docs/architecture.md`](docs/architecture.md) for the detailed flow and design choices.

## Setup

### Prerequisites

- An **n8n Cloud** account (free trial works) — [n8n.cloud](https://n8n.cloud)
- A **Google Gemini API key** (free) — [aistudio.google.com/app/apikey](https://aistudio.google.com/app/apikey)
- A **Tavily API key** (free, 1,000 searches/month) — [tavily.com](https://tavily.com)
- A GitHub account (for hosting this repo as portfolio)

### Import the workflow

1. Open your n8n Cloud workspace.
2. Click **Workflows → Import from File…** (top right of the canvas).
3. Upload `workflow/business-agent-workflow.json`.
4. Open the imported workflow.
5. Add your **Tavily API key**: click the *Tavily Web Search* node → in the JSON Body field, replace `PASTE_YOUR_TAVILY_KEY_HERE` with your actual key (starts with `tvly-`).
6. Add your **Gemini credential**: click the *Google Gemini Chat Model* node → *Credential to connect with* → *+ Create New Credential* → type *Google Gemini(PaLM) API* → name it `Google Gemini API` → paste your key → Save.
7. Save the workflow.
8. Click **Chat** (bottom-left of the n8n UI) to open the chat panel and test.

### Try the demo queries

Open `docs/demo-script.md` and run the three example queries. Watch the **Execution log** to see the agent's tool-call decisions.

## Files

```
agentic-business-assistant/
├── README.md                          ← you are here
├── workflow/
│   └── business-agent-workflow.json   ← import this into n8n
├── prompts/
│   └── system-prompt.md               ← the agent's instructions (editable)
├── docs/
│   ├── architecture.md                ← flow diagram + design choices
│   └── demo-script.md                 ← 3 example queries with expected outputs
├── screenshots/                       ← add portfolio screenshots here
└── .gitignore
```

## Customizing

- **Add a tool** — drop a new **HTTP Request Tool** node onto the canvas, fill its description, and connect it to the AI Agent's `ai_tool` input. Mention it in `prompts/system-prompt.md`.
- **Swap the LLM** — replace the Google Gemini Chat Model node with Anthropic Claude or OpenAI; update the system prompt if needed.
- **Geocode for any city** — replace the hardcoded Bangkok coordinates with a geocoding step (Open-Meteo's `/v1/search` resolves a city name → coords → forecast).
- **Move the Tavily key out of the JSON** — for production, swap body auth (`api_key` field in `jsonBody`) for a credential of type *Header Auth* named `Tavily API` with Header Name `Authorization` and Value `Bearer tvly-YOUR_KEY`, then add `authentication: genericCredentialType` and `genericAuthType: httpHeaderAuth` back to the tool node parameters. See the `toolHttpRequest` node docs.

## Roadmap

- [ ] Multi-city weather via geocoding
- [ ] Tavily web search for time-sensitive topics (news, recent events)
- [ ] Output parser to enforce JSON schema for downstream automation
- [ ] Slack delivery of the agent's response
- [ ] Eval suite with golden queries and ground-truth checks

## License

MIT — do whatever you want with this.