# Nitrograph plugin for Claude Code

Discover, inspect, and call agent-usable APIs via [Nitrograph](https://nitrograph.com), the discovery layer agents call before they spend money on a service.

Nitrograph ranks services by task fit, health, trust, cost, and prior agent outcomes, then returns the service detail and call card needed to use the selected provider safely.

## What you get

- **Seven MCP tools** auto-loaded from the hosted HTTP server at `https://api.nitrograph.com/mcp`:
  - `nitrograph_discover`: search the registry by natural-language task
  - `nitrograph_service_detail`: fetch endpoints, OpenAPI, gotchas, proven patterns for a slug
  - `nitrograph_invoke_service`: call the selected service through Nitrograph; outcome is recorded automatically
  - `nitrograph_authenticate`: verify a key, or start device pairing so the agent mints its own spend-capped key
  - `nitrograph_report_outcome`: record success/failure of a call you made directly, feeding the trust signal
  - `nitrograph_report_pattern`: report a successful multi-step workflow
  - `nitrograph_session_status`: check remaining quota without consuming any
- **`/discover <query>`** slash command: quick one-shot search.
- **`nitrograph` skill**: auto-invoked when you ask Claude to find, compare, or call an API for a task.

## Install

```text
/plugin marketplace add nitrographtech/claude-plugins
/plugin install nitrograph@nitrograph
```

Restart Claude Code after installation so the MCP tools, skill, and slash command are loaded.

## Authenticate (for paid calls)

Discovery is free and needs no account. To let the agent **invoke** paid
services, connect once - no key to paste:

- **OAuth (recommended):** `claude mcp add --transport http nitrograph https://api.nitrograph.com/mcp`, then `/mcp` → **Authenticate**. One consent sets spend caps ($1/call, $20/day, $200/month by default); the host holds tokens, you never see a secret. Your first **certified** call is free (a one-time $1 certified-only credit is seeded on connect).
- **In-chat pairing:** ask the agent to authenticate - it calls `nitrograph_authenticate`, hands you a short code for [nitrograph.com/pair](https://nitrograph.com/pair), and receives its own spend-capped key after your one-time approval.
- **Manual key (scripts/CI):** create a key at [nitrograph.com/dashboard](https://nitrograph.com/dashboard) and set `NITROGRAPH_API_KEY`.

Every paid call is quoted, validated, refunded on failure, and receipted.

## Use

```text
/discover lead generation
```

Or ask naturally:

```text
Find me a lead generation API and show the best options with pricing.
```

```text
Find an image generation service under $0.05 per call.
```

```text
Find a data enrichment API, inspect the top result, and show me the call card.
```

## How it works

The plugin connects Claude Code to Nitrograph's hosted HTTP MCP server at `https://api.nitrograph.com/mcp`. No API key is required for the free tier. If you hit the free quota, Nitrograph returns pay-to-continue instructions.

## Agent Rules

- Use discovery first, then fetch service detail for the selected service before calling it.
- Do not invent endpoints from discovery results.
- Do not send default or empty filters. Omit filters unless the user explicitly asks for a rail, category, or price ceiling.
- Treat `402 Payment Required` as a payment challenge, not as a failed service call.
- Report outcomes only after a provider actually ran and returned success or a genuine provider failure.

## Safety

- Nitrograph processes the discovery queries, task context, outcome reports, and pattern reports that you or your agent send to Nitrograph.
- Do not send secrets, private keys, bearer tokens, raw customer payloads, confidential customer data, or full downstream service responses in discovery queries or reports.
- You control which downstream services your agent calls and what it pays for.

## Links

- Website: <https://nitrograph.com>
- Docs: <https://nitrograph.com/docs>
- Privacy: <https://nitrograph.com/privacy>
- Terms: <https://nitrograph.com/terms>
- npm package: <https://www.npmjs.com/package/nitrograph>

## License

MIT
