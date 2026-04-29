# Nitrograph plugin for Claude Code

Discover, inspect, and call agent-usable APIs via the [Nitrograph](https://nitrograph.com) service-discovery network.

## What you get

- **Four MCP tools** auto-loaded into your session:
  - `nitrograph_discover` — search the registry by natural-language task
  - `nitrograph_service_detail` — fetch endpoints, OpenAPI, gotchas, proven patterns for a slug
  - `nitrograph_report_outcome` — record success/failure of a call (feeds the trust signal)
  - `nitrograph_report_pattern` — report a successful multi-step workflow
- **`/discover <query>`** slash command — quick one-shot search.
- **`nitrograph` skill** — auto-invoked when you ask Claude to find, compare, or call an API for a task.

## Install

```
/plugin marketplace add nitrographtech/claude-plugins
/plugin install nitrograph@nitrograph
```

## Use

```
/discover send transactional email
```

Or just ask: "find me an API that does text-to-speech with SSML support."

## How it works

The plugin runs the Nitrograph stdio MCP server (`npx -y nitrograph server`), which proxies to `https://api.nitrograph.com`. No API key required — free tier; pay-to-continue via x402 USDC on Base when you hit the free quota.

## License

MIT
