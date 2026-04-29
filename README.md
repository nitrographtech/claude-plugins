# Nitrograph Claude Code Plugins

Official Claude Code marketplace for [Nitrograph](https://nitrograph.com).

Nitrograph is the discovery layer agents call before they spend money on a service. It finds agent-usable APIs across x402, MPP, and other payment rails, ranks them by task fit and operational signals, and returns the service details needed to call the selected provider safely.

## Plugins

| Plugin | Description |
|--------|-------------|
| `nitrograph` | Discover, inspect, and call agent-usable APIs via Nitrograph. Adds the hosted Nitrograph workflow as MCP tools, the `nitrograph` skill, and a `/discover` command. |

## Install

```text
/plugin marketplace add nitrographtech/claude-plugins
/plugin install nitrograph@nitrograph
```

Restart Claude Code after installation so the MCP tools, skill, and slash command are loaded.

## Try It

```text
/discover lead generation
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
