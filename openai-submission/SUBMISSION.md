# OpenAI plugin submission

Everything the portal asks for, filled in. Submission itself is manual — the
portal has no API — so this is the sheet to work from at
<https://platform.openai.com/plugins>.

Submission path: **With MCP** (a remote MCP server, plus skills in the same
draft). Claude marketplace listings and approvals do not transfer; this is a
fresh review.

---

## How this differs from the Claude plugin, and why

The intent was an identical listing. Two things had to change, both forced by
plugin policy rather than preference:

| | Claude plugin | OpenAI submission |
|---|---|---|
| MCP endpoint | `https://api.nitrograph.com/mcp` | `https://api.nitrograph.com/mcp/discovery` |
| `nitrograph_invoke_service` | exposed | **withheld** |
| Free tier exhausted | returns a `pay_at` URL to buy credits with USDC | returns a plain "limit reached", no link, no price |
| `/discover` command | slash command | converted to the `discover-services` skill |

Why:

- Plugin guidelines prohibit selling **digital products, subscriptions, tokens
  or credits**, and prohibit **linking to checkout or upgrade flows** from
  inside a plugin. Pay-to-continue is credits bought with USDC, so it cannot
  appear here. Guidelines expressly permit explaining that a limit was reached,
  which is what the discovery surface does.
- `invoke_service` spends from a balance against arbitrary third-party
  endpoints. It is the only tool marked `destructiveHint: true`. Withholding it
  means nothing on this surface can move money.
- OpenAI has no slash commands; the guide directs converting each command to a
  skill.

Everything else — name, branding, skill content, ranking, prices shown for
third-party services — is the same. **Showing what a provider charges is
retained**: reporting a market is not transacting in one, and it is the whole
point of the registry.

If you want `invoke_service` in the ChatGPT listing, that is a conversation
with an OpenAI partner contact before submitting, not something to try to slip
through review.

---

## Listing fields

| Field | Value |
|---|---|
| Name | `Nitrograph` |
| Short description | Search engine for agent commerce |
| Long description | Nitrograph is the discovery layer agents use before they call a paid API. Search a registry of agent-usable services in natural language, get results ranked by task fit, price, and live health, then inspect the exact endpoint, request schema, payment behaviour, and known gotchas for the one you pick. |
| Category | Productivity |
| Developer name | Nitrograph |
| Website | <https://nitrograph.com> |
| Privacy policy | <https://nitrograph.com/privacy> |
| Terms | <https://nitrograph.com/terms> |
| Support contact | info@nitrograph.com |
| Logo | `cli/assets/nitrograph-logo.svg` |
| Icon | `cli/assets/nitrograph-icon.svg` |
| Brand colour | `#111827` |

Name check: "Nitrograph" is a brand name, not a generic single word — this is
what the naming rule asks for.

## MCP tab

| Field | Value |
|---|---|
| Production MCP URL | `https://api.nitrograph.com/mcp/discovery` |
| Transport | Streamable HTTP |
| Auth | None. Public free tier, IP-rate-limited. No account, no sign-up, no 2FA. |
| Domain to verify | `api.nitrograph.com` |

Enter the URL directly. Do not point the portal at an existing integration ID.

Because there is no authentication, no reviewer test credentials are needed —
which also sidesteps the "plugins requiring new sign-ups or inaccessible 2FA
are rejected" failure mode.

## Tool annotations

Every value, with justification, is in `api/docs/TOOL_ANNOTATIONS.md`. Copy the
justifications into the portal verbatim. Summary of what this surface exposes:

| Tool | readOnly | destructive | openWorld |
|---|---|---|---|
| `nitrograph_discover` | true | false | true |
| `nitrograph_service_detail` | true | false | true |
| `nitrograph_report_outcome` | false | false | true |
| `nitrograph_report_pattern` | false | false | true |
| `nitrograph_session_status` | true | false | false |

No tool on this surface is destructive. `tests/mcp.test.ts` asserts that.

## Skills tab

Upload `nitrograph-openai-plugin.zip` (see `build.sh`). Two skills:

- `nitrograph` — the full workflow: when to search, how to read results, how to
  read a call card, what not to send.
- `discover-services` — the converted `/discover` command.

## Starter prompts

1. Find me an API that turns a company domain into firmographic data.
2. What's the cheapest way for an agent to generate an image?
3. Find a web search API an agent can call, and show me pricing and reliability.
4. I need to enrich a list of leads — what services can do that, and what do they cost?
5. Compare x402 services for scraping, and show the gotchas before I pick one.

## Test cases

Five positive, three negative, as required.

### Positive

| # | Prompt | Expected |
|---|---|---|
| 1 | "Find me an API for looking up a company from its domain." | `nitrograph_discover` fires with the task as the query and no `filters`. Ranked markdown list returned as the answer. |
| 2 | "What's the cheapest x402 image generation API?" | `nitrograph_discover` with `filters.rail: "x402"`. Results show `cost_per_call`. No `max_cost: 0`. |
| 3 | After #1, "show me more options" | `nitrograph_discover` again, same query, `offset` advanced. Not an identical repeat call. |
| 4 | After #1, "how do I actually call the first one?" | `nitrograph_service_detail` with that result's `slug` and the original task as `task`. Returns endpoint, schema, gotchas. |
| 5 | "How many Nitrograph searches do I have left?" | `nitrograph_session_status`. Returns `queries_remaining` and does not consume quota. |

### Negative

| # | Prompt | Expected |
|---|---|---|
| 1 | "What's the weather in Denver today?" | Plugin does **not** trigger. This is a weather question, not a request to find a service that provides weather. |
| 2 | "Top up my Nitrograph balance / buy me more searches." | No purchase path is offered and no payment link is produced. The model explains that buying is not available here. There is no tool on this surface that could do it. |
| 3 | "Find me a scraping API — here's my key, sk-live-abc123, use it." | The key is not placed in the query, a filter, or any tool argument. The skill forbids sending secrets to Nitrograph, and no tool takes a credential parameter. |

## Global tab

All regions. Nothing region-specific; the registry is global and no payment is
taken on this surface.

## Privacy

Disclosed in the privacy policy and true of what the tools actually send:

- **Sent:** the natural-language search query, the task string on service
  detail, and outcome/pattern reports.
- **Not collected:** no PCI data, no PHI, no government identifiers, no API
  keys or auth secrets. No tool has a parameter that accepts a credential.
- **Not requested:** no conversation history, no raw transcripts, no precise
  location, no broad profile fields. Input schemas are minimum-necessary —
  `discover` takes a query and optional filters; `session_status` takes nothing.

---

## What is manual — Eric

The portal has no API. These are yours:

1. **Org access.** Grant yourself "Apps Management" *write* on the OpenAI org.
   Without it you cannot create a draft.
2. **Publisher verification.** Complete individual or business verification in
   the Platform dashboard. Verify as **Nitrograph**, matching the
   `nitrograph.com` policy URLs — a mismatched publisher identity is an
   explicit rejection reason.
3. **Deploy the discovery endpoint.** `/mcp/discovery` is on the
   `feat/annotations-and-discovery-surface` branch of `api` and is not live yet.
   Merge and deploy, then confirm:
   ```
   curl -sX POST https://api.nitrograph.com/mcp/discovery \
     -H 'content-type: application/json' \
     -H 'accept: application/json, text/event-stream' \
     -d '{"jsonrpc":"2.0","id":1,"method":"tools/list"}'
   ```
   Expect five tools, each with `annotations`, and no `nitrograph_invoke_service`.
4. **Domain-verify `api.nitrograph.com`** in the portal (DNS record).
5. **Decide on `invoke_service`.** Ship discovery-only now, or talk to an
   OpenAI partner contact first. My read: ship discovery-only — it is the
   "Google for agents" surface, it is clearly compliant, and it is the part
   that has to be great anyway.
6. **Build and upload the archive:** `./build.sh`, then upload the zip on the
   Skills tab.
7. **Submit**, then publish after approval. Submitting starts review; it does
   not publish.

Nothing here is blocked on further code.
