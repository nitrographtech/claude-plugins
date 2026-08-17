---
name: discover-services
description: Search for an API or service that can perform a task. Use when the user asks to find, search for, compare, price, or choose an API, provider, integration, or paid service — including phrasings like "is there an API for", "what's the cheapest way to", or "find me a service that".
---

# Find a service for a task

Converted from the `/discover` command. OpenAI plugins have no slash commands,
so the same behaviour is a skill the model triggers from intent.

## Steps

1. Take the user's task as the query. Pass it to `nitrograph_discover` in
   natural language — do not reduce it to keywords, the ranking is semantic.
2. Do not send `filters` unless the user explicitly constrained the search by a
   payment rail, a category, a price ceiling, or a trust floor.
3. The tool returns a pre-rendered ranked markdown list. Present it as the
   answer. Do not reorder it, regroup it, or add services of your own that the
   registry did not return.
4. Keep `related_results` separate and clearly lower-confidence. Do not promote
   them into the main recommendations.
5. If the response reports `has_more` and the user wants more options, call
   `nitrograph_discover` again with the same query and `offset` advanced past
   what was already shown. Do not repeat the identical call.
6. To go deeper on one result, take its `slug` and call
   `nitrograph_service_detail`, passing the user's original task as `task` so
   the endpoint options are ranked for it.

## Reporting a result

If the user (or the model on the user's behalf) actually calls one of these
services afterwards, record what happened with `nitrograph_report_outcome`.
That is what keeps the rankings honest for the next search. Report only real
successes and real provider failures, with a generalized diagnosis — never raw
request or response data.

## Limits

If a search reports that the limit for the current window has been reached,
say so plainly and stop. Do not retry in a loop and do not look for a way
around it.
