# Email Countdowns REST API

Use this when MCP tools are not connected: scripts, CI jobs, ChatGPT Custom GPT actions, or any agent that can make HTTP requests.

Base URL: `https://emailcountdowns.com/api`

## Authentication

The workspace owner creates a key under Team API key at https://emailcountdowns.com/workspace. Creating a new key replaces the old one. Send it as a bearer token:

```
Authorization: Bearer $COUNTDOWN_API_KEY
Accept: application/json
Content-Type: application/json
```

The key belongs to one workspace. Keep it out of chat logs, commits and email HTML. Read it from an environment variable.

## Create a countdown

`POST /api/countdowns`

```sh
curl -sS -X POST 'https://emailcountdowns.com/api/countdowns' \
  -H "Authorization: Bearer $COUNTDOWN_API_KEY" \
  -H 'Accept: application/json' -H 'Content-Type: application/json' \
  -d '{
    "campaign_key": "winter-sale-2026",
    "name": "Winter sale ends",
    "date": "2026-12-18",
    "time": "17:00",
    "timezone": "Europe/London"
  }'
```

| Field | Required | Rule |
|---|---|---|
| `name` | yes | string, max 255 |
| `date` | yes | `YYYY-MM-DD` |
| `time` | yes | `HH:MM`, 24-hour |
| `timezone` | yes | IANA timezone |
| `campaign_key` | no, recommended | string, max 120. Same key + same body returns the existing timer. |
| `description` | no | string, max 1,000 |
| `style_id` | no | existing style ID |
| `font_id` | no | existing font ID |
| `text_colour` | no | `#RRGGBB` |
| `background_colour` | no | `#RRGGBB` or `transparent` |

Responses:

- `201 Created` for a new timer, `200 OK` when an identical `campaign_key` request returns the existing one.
- `422` with `errors` for validation failures, including a past deadline or a reused key with different settings.
- `401` when the key is missing or revoked.

Body:

```json
{
  "data": {
    "id": 123,
    "name": "Winter sale ends",
    "description": null,
    "expires_at": "2026-12-18T17:00:00+00:00",
    "timezone": "Europe/London",
    "style_id": 1,
    "font_id": 1,
    "text_colour": "#000000",
    "background_colour": "#ffffff",
    "gif_url": "https://emailcountdowns.com/countdown/public/123.gif",
    "embed_html": "<img src=\"https://emailcountdowns.com/countdown/public/123.gif\" alt=\"Winter sale ends\" width=\"300\" style=\"max-width:100%;border:0;display:block;\" />",
    "created_at": "2026-11-19T10:00:00+00:00",
    "updated_at": "2026-11-19T10:00:00+00:00"
  }
}
```

`expires_at` is in UTC.

## Other endpoints

| Method | Path | Purpose |
|---|---|---|
| `GET` | `/api/countdowns` | List the workspace's timers, newest first, in `data`. |
| `GET` | `/api/countdowns/{id}/embed` | Return `url`, `html`, `name` and `expires_at` for one timer. |
| `PUT` | `/api/countdowns/{id}` | Update `name`, `description`, `style_id`, `font_id`, `text_colour`, `background_colour`. To move the deadline, send `date`, `time` and `timezone` together. The image URL stays the same, so emails already sent pick up the change. |
| `DELETE` | `/api/countdowns/{id}` | Delete. Returns `204`. Every sent email using this image loses it. Ask the user first. |

## Python

```python
import os, requests

resp = requests.post(
    "https://emailcountdowns.com/api/countdowns",
    headers={
        "Authorization": f"Bearer {os.environ['COUNTDOWN_API_KEY']}",
        "Accept": "application/json",
    },
    json={
        "campaign_key": "winter-sale-2026",
        "name": "Winter sale ends",
        "date": "2026-12-18",
        "time": "17:00",
        "timezone": "Europe/London",
    },
    timeout=30,
)
resp.raise_for_status()
timer = resp.json()["data"]
print(timer["embed_html"])
```

## Node

```js
const res = await fetch("https://emailcountdowns.com/api/countdowns", {
  method: "POST",
  headers: {
    Authorization: `Bearer ${process.env.COUNTDOWN_API_KEY}`,
    Accept: "application/json",
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    campaign_key: "winter-sale-2026",
    name: "Winter sale ends",
    date: "2026-12-18",
    time: "17:00",
    timezone: "Europe/London",
  }),
});
if (!res.ok) throw new Error(`${res.status} ${await res.text()}`);
const { data } = await res.json();
console.log(data.embed_html);
```
