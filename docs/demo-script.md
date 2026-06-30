# Demo Script

Three sample queries that exercise the agent's reasoning, tool use, and synthesis. Use these to record a 60-second screen-capture walkthrough for your portfolio.

---

## Query 1 — Multi-tool, retail + weather

**Input:**

> Give me background on Charoen Pokphand Group and how their retail division might be affected by Bangkok's weather this week.

**Expected flow:**

1. Agent calls `Tavily Web Search` with `query="Charoen Pokphand Group retail operations 2026"`
2. Agent calls `Open-Meteo Bangkok Weather` for current conditions
3. Agent synthesizes both into a structured answer

**Expected output (abridged):**

> **Summary** — CP Group is Thailand's largest private conglomerate with significant retail exposure (7-Eleven Thailand, Makro, Lotus's). Bangkok is currently ~X°C with Y mm precipitation, which may affect foot traffic and supply logistics.
>
> **Context** — Founded in 1921 as a seed shop, CP Group now operates across retail, food, telecom, and logistics. Its retail arm, CP Retailink, runs over 13,000 7-Eleven stores in Thailand...
>
> **Sources**
> - cpgroupglobal.com — Corporate overview
> - bangkokpost.com — Recent retail expansion coverage
> - reuters.com — Quarterly earnings highlight
>
> **Operational Notes** — Current Bangkok temperature is X°C with precipitation of Y mm. Heavy precipitation typically reduces convenience-store foot traffic by ~10–15%; logistics teams should expect delivery delays.
>
> **Recommended Next Steps**
> - Brief retail ops on weather contingency.
> - Review CP Group's latest quarterly report for retail resilience signals.

**What this exercises:** Multi-tool planning, parallel tool calls, live web research + synthesis.

---

## Query 2 — Single tool, banking context

**Input:**

> Brief me on Siam Commercial Bank for a client meeting tomorrow.

**Expected flow:**

1. Agent calls `Tavily Web Search` with `query="Siam Commercial Bank SCBX history recent news"`
2. Agent skips weather (not relevant to this question).
3. Agent synthesizes a briefing.

**Expected output (abridged):**

> **Summary** — Siam Commercial Bank (SCB) is one of Thailand's oldest and largest banks, part of the SCBX group since 2022.
>
> **Context** — Founded in 1906 under royal charter, SCB is the first Thai commercial bank. The 2021–2022 restructuring created SCBX as the parent holding company...
>
> **Sources**
> - scb.co.th — Corporate profile
> - scbx.com — Holding company structure
> - reuters.com — Recent strategic moves
>
> **Recommended Next Steps**
> - Pull the latest SCBX annual report before the meeting.
> - Ask the client about their exposure to Thai consumer credit trends.

**What this exercises:** Tool selection (agent knows weather isn't relevant), live web synthesis quality.

---

## Query 3 — Tricky, tool-not-applicable

**Input:**

> What's the stock price of PTT today?

**Expected flow:**

1. Agent recognizes no available tool covers live stock prices.
2. Agent responds honestly and suggests alternatives.

**Expected output:**

> **Summary** — I cannot retrieve live stock prices with my current tools. My available tools cover live web search (Tavily) and Bangkok weather.
>
> **Suggested alternatives**
> - For PTT's current price, check the Stock Exchange of Thailand website (set.or.th) or your broker's terminal.
> - I can use Tavily to pull recent news or analyst commentary on PTT if that would help.

**What this exercises:** Honest failure handling — no fabrication. Critical for production trust.

---

## Recording tips

- 60-second video max. Screen-record the **n8n Chat panel + Execution log** so viewers see the tool calls fire.
- Use the **Agent Steps** view in n8n to show: input → tool call → tool response → synthesis.
- Add captions: "Multi-tool planning" · "Tool execution" · "Synthesis with structure" · "Honest refusal when no tool applies".
- End with a 3-second card showing the GitHub repo URL.

## Portfolio framing (use in your README / resume)

> Built an agentic AI assistant in n8n (LangChain + Google Gemini) that autonomously selects and calls Tavily web search and weather APIs to answer business research queries. Implemented tool-use reasoning, source-grounded synthesis, session memory, and error handling — deployed on n8n Cloud with full documentation.
