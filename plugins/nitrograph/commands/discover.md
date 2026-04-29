---
description: Search the Nitrograph registry for agent-usable services matching the user's task
---

Use the `nitrograph_discover` MCP tool to search the Nitrograph service registry.

The user's query: $ARGUMENTS

Pass the query directly to `nitrograph_discover`. The tool returns a pre-rendered ranked list — emit it verbatim as the response. Do not reorder, regroup, or add commentary. To follow up on a specific service, extract its slug from the backticks and call `nitrograph_service_detail`.
