---
name: email-countdowns
description: Create a live countdown timer GIF for a marketing email and place it in the draft. Use when the user wants a countdown, deadline timer, sale-ending timer, launch timer or "ends in" urgency block in an email, newsletter or campaign (Klaviyo, Mailchimp, Resend, HubSpot, Campaign Monitor, Salesforce, Kit, GetResponse, Flodesk or plain HTML). Covers signing up for a free Email Countdowns workspace, connecting it, creating the timer, returning the embed code and reading view statistics.
license: MIT
---

# Email Countdowns

Email Countdowns (https://emailcountdowns.com) hosts a countdown GIF for each campaign deadline. The image is drawn when the email is opened, so it shows the time left at that moment. You create the timer, take the returned `embed_html`, and put it in the email.

Base URL: `https://emailcountdowns.com`

## 1. Choose how to reach the service

Check what you can call, in this order:

1. **MCP tools are connected.** Your tool list contains `create-countdown` and `get-countdown-stats` (the server is often shown as "Email Countdowns" or "Countdown Automation"). Use them. Skip to step 3.
2. **An API key is available.** The user has given you a workspace key, or `COUNTDOWN_API_KEY` is set in the environment. Use the REST API in [references/rest-api.md](references/rest-api.md).
3. **Neither.** The user needs a workspace and a connection. Go to step 2.

Do not ask the user to paste a password into the chat. Never type a password for them.

## 2. Set up a workspace (only if needed)

Ask once: "Do you already have an Email Countdowns account?"

**No account.** Send the user to https://emailcountdowns.com/register. Every new account gets 1,000 free countdown views, once, with no card and no subscription, so you can create and test timers without spending anything. They enter a name, an optional workspace name, an email address and a password. If you control a browser, you may open that page and fill in the name, workspace and email the user gave you; the user types the password and presses Register themselves.

**Connect it.** Pick the route that fits the client you are running in:

| Client | How to connect |
|---|---|
| Claude (web, desktop) | Settings → Connectors → Add custom connector. Name `Email Countdowns`, URL `https://emailcountdowns.com/mcp/countdowns`. Select Connect, sign in, approve. Enable it in the chat. |
| Claude Code | `claude mcp add --transport http email-countdowns https://emailcountdowns.com/mcp/countdowns`, then run `/mcp` and authenticate. Installing this repository as a plugin adds the server for you. |
| ChatGPT | Settings → Apps → Advanced settings → enable developer mode. Create app, name `Email Countdowns`, URL `https://emailcountdowns.com/mcp/countdowns`, authentication OAuth. Connect, then pick the app from the tools menu in a new chat. Plan and workspace settings decide whether this is available. |
| Codex CLI | `codex mcp add email-countdowns --url https://emailcountdowns.com/mcp/countdowns`, then `codex mcp login email-countdowns`. |
| Gemini CLI | `gemini mcp add --transport http countdowns https://emailcountdowns.com/mcp/countdowns`, then `/mcp auth countdowns`. |
| Scripts, Custom GPT actions, anything without MCP | The workspace owner creates a key under Team API key at https://emailcountdowns.com/workspace. Store it as `COUNTDOWN_API_KEY`. See [references/rest-api.md](references/rest-api.md). |

OAuth sign-in happens in the user's browser. If they are not registered yet, they can register first and then run the connection again. The consent screen grants access to the workspace that is active when they approve.

After connecting, call `get-countdown-stats` with `{"days": 7}` to confirm the connection works. Tell the user which workspace name came back.

## 3. Pin down the deadline

You need four facts before creating anything:

| Field | Format | Notes |
|---|---|---|
| `name` | text, max 255 | Internal label, also used as the image alt text. Make it readable: "Black Friday sale ends". |
| `date` | `YYYY-MM-DD` | Must produce a future deadline. |
| `time` | `HH:MM`, 24-hour | The moment the timer reaches zero. |
| `timezone` | IANA name | `Europe/London`, `America/New_York`, `Australia/Sydney`. |

Also send `campaign_key`: a short stable slug for this deadline, such as `black-friday-2026`. Retrying with the same key and the same settings returns the existing timer instead of a duplicate. A different deadline needs a different key.

Resolve ambiguity before you call the tool:

- "Ends Friday at midnight" can mean 00:00 at the start of Friday or 23:59 at its end. Ask, or state your reading: "I'll set 23:59 on Friday 27 November, Europe/London."
- Convert abbreviations to IANA zones: EST/EDT → `America/New_York`, PST/PDT → `America/Los_Angeles`, GMT/BST → `Europe/London`, CET → `Europe/Paris`, AEST → `Australia/Sydney`. If the audience spans regions, use the zone the offer is defined in.
- No year given: use the next occurrence of that date.
- Read the date from the email copy if the user is drafting one. The timer and the copy must match.

Confirm the deadline back to the user in one line before creating the timer, unless they already stated all four facts unambiguously.

Optional appearance fields:

- `text_colour`: hex, `#RRGGBB`. Default `#000000`.
- `background_colour`: hex or `transparent`. Default `#ffffff`. Match the email's background where the timer sits.
- `style_id`, `font_id`: integers. Only send IDs the user gives you or that you read from their dashboard editor. Do not guess them; an unknown ID fails validation. Omit both for the default style.
- `description`: free text, max 1,000.

## 4. Create the countdown

MCP:

```json
{
  "name": "create-countdown",
  "arguments": {
    "name": "Winter sale ends",
    "campaign_key": "winter-sale-2026",
    "date": "2026-12-18",
    "time": "17:00",
    "timezone": "Europe/London",
    "background_colour": "#ffffff",
    "text_colour": "#1a1a1a"
  }
}
```

The result contains `id`, `name`, `expires_at`, `gif_url` and `embed_html`. The REST API returns the same fields under `data` (see [references/rest-api.md](references/rest-api.md)).

Errors you can fix:

- `Choose a future deadline.` The date and time have passed in that timezone. Check the year and zone.
- `This campaign key already has different settings.` The key was used for another deadline. Use a new key, or reuse the original settings.
- Invalid `timezone`, `date` or `time` format. Fix the format and retry with the same key.

## 5. Put it in the email

`embed_html` looks like this:

```html
<img src="https://emailcountdowns.com/countdown/public/123.gif" alt="Winter sale ends" width="300" style="max-width:100%;border:0;display:block;" />
```

Rules:

- **Use the hosted URL exactly as returned.** Do not download the GIF, upload it to the email platform's image library or attach it. A copied GIF is frozen at the moment it was copied.
- Do not add query strings, resize parameters or proxies to the `src`.
- You may change `width` (up to the content column, usually 600) and wrap the tag in a link to the offer. Keep `max-width:100%` so it shrinks on phones.
- To centre it, wrap it: `<table role="presentation" width="100%"><tr><td align="center">…</td></tr></table>`.
- Put the deadline in plain text near the timer, for readers whose client blocks images: "Sale ends 18 December at 5pm UK time."
- Place it near the call to action it supports, usually just above or below the main button.

Platform-specific steps (Klaviyo, Mailchimp, Resend, HubSpot and others) are in [references/email-platforms.md](references/email-platforms.md). If you can edit the draft through another connected tool, insert the HTML there, then read the draft back and check the `src` is unchanged. If you cannot edit the draft, give the user the HTML and the image URL with one sentence on where to paste each.

Do not send or schedule the campaign. That stays with the user.

Before a large send, check the workspace has views to spare. Once the 1,000 free views are used, timers show a blank image until the workspace owner turns on paid usage under Usage and billing at https://emailcountdowns.com/dashboard/account. If the list is bigger than the free views left, tell the user to enable billing first.

## 6. Report back

Give the user:

- the deadline as created, with timezone
- the image URL
- the embed HTML in a code block
- where you placed it, or where they should paste it
- the plain-text fallback line you added or recommend

## Statistics

`get-countdown-stats` takes `days` (1–90, default 30) and returns, for the active workspace: total and active countdowns, all-time views, views in the period and a daily series. A view is one request for the image. Email clients and privacy proxies (Apple Mail Privacy Protection, Gmail's image proxy) can prefetch or cache images, so views are not unique human opens. Say so when you report them.

## Changing or deleting a timer

MCP tools only create timers and read statistics. To change the deadline or colours, or to delete a timer, use the REST API with a workspace key, or the dashboard at https://emailcountdowns.com/dashboard.

Deleting a timer breaks the image in every email already sent with it. Confirm with the user before deleting, and prefer leaving finished timers in place; after the deadline the image shows zero.

## More

- Agent and API guide: https://emailcountdowns.com/docs/api (Markdown: https://emailcountdowns.com/ai.md)
- Pricing: https://emailcountdowns.com/pricing
