# Nitrograph Claude Code Plugins

Official Claude Code marketplace for [Nitrograph](https://nitrograph.com).

Nitrograph is the discovery layer agents call before they spend money on a service. It finds agent-usable APIs across x402, MPP, and other payment rails, ranks them by task fit and operational signals, and returns the service details needed to call the selected provider safely.

## Plugins

| Plugin | Description |
|--------|-------------|
| `nitrograph` | Discover, inspect, and call agent-usable APIs via Nitrograph. Adds the hosted Nitrograph workflow as MCP tools, the `nitrograph` skill, and a `/discover` command. |
| `nitrograph-research` | Validated, pay-per-result research and enrichment (also listed in this marketplace). |

### Tools

| Tool | Purpose |
|------|---------|
| `nitrograph_discover` | Search and rank services for a task (`limit`, `offset`, optional `filters`) |
| `nitrograph_service_detail` | Full call card for one service |
| `nitrograph_invoke_service` | Call the service through Nitrograph, outcome recorded automatically |
| `nitrograph_authenticate` | Verify a key, or start device pairing so the agent mints its own spend-capped key |
| `nitrograph_report_outcome` | Record success/failure of a direct call |
| `nitrograph_report_pattern` | Record a reusable workflow |
| `nitrograph_session_status` | Check remaining quota without consuming any |

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

## Try It

```text
/discover lead generation
```

```text
Use Nitrograph to find a web search API, then call the top result.
```

```text
Use Nitrograph to find an image generation service under $0.05 per call.
```

```text
Use Nitrograph to find a data enrichment API, inspect the top result, and show me the call card.
```

## Safety

- Nitrograph processes the discovery queries, task context, outcome reports, and pattern reports that you or your agent send to Nitrograph.
- Do not send secrets, private keys, bearer tokens, raw customer payloads, confidential customer data, or full downstream service responses in discovery queries or reports.
- Always inspect service detail before invoking a paid service.
- Treat `402 Payment Required` as a payment challenge, not as a failed service call.

## Links

- Website: <https://nitrograph.com>
- Docs: <https://nitrograph.com/docs>
- Privacy: <https://nitrograph.com/privacy>
- Terms: <https://nitrograph.com/terms>
- npm package: <https://www.npmjs.com/package/nitrograph>

## License

MIT
