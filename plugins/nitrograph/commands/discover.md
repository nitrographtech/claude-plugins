---
description: Search the Nitrograph registry for agent-usable services matching the user's task
---

Use the `nitrograph_discover` MCP tool to search the Nitrograph service registry.

The user's query: $ARGUMENTS

Pass the query directly to `nitrograph_discover`. Do not include filters unless the user explicitly asked for a rail, category, or price ceiling.

The tool returns a pre-rendered ranked list. Emit it verbatim as the response. Do not reorder, regroup, or add commentary. To follow up on a specific service, extract its slug from the backticks and call `nitrograph_service_detail` with the original task as context.

If the response reports `has_more` and the user asks for more, call `nitrograph_discover` again with the same query and `offset` advanced past what you already showed. Do not re-run the identical call.
