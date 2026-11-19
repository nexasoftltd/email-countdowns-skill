# Email Countdowns skill: animated countdown timers for email, made by your AI agent

Ask Claude or ChatGPT for "a countdown to our sale ending Friday at 5pm". This skill helps you sign up for [Email Countdowns](https://emailcountdowns.com) if you need an account, creates a live animated countdown GIF for the deadline, and puts the embed code in the email you are drafting.

```
You:    Add a countdown to the winter sale email. Sale ends 18 December, 5pm UK time.
Agent:  Created "Winter sale ends" for 18 Dec 2026 17:00 Europe/London.
        Inserted above the Shop now button in your Klaviyo draft.
        Added the line "Sale ends 18 December at 5pm UK time" under it.
```

The skill follows the open Agent Skills format (a `SKILL.md` file with references), so the same folder works in Claude, Claude Code, ChatGPT, Codex and other clients that read skills.

## Contents

- [How an animated email countdown works](#how-an-animated-email-countdown-works)
- [Install](#install)
- [Create your first countdown](#create-your-first-countdown)
- [Add the countdown to Klaviyo, Mailchimp and other platforms](#add-the-countdown-to-klaviyo-mailchimp-and-other-platforms)
- [Use it without MCP: REST API and Custom GPTs](#use-it-without-mcp-rest-api-and-custom-gpts)
- [FAQ](#faq)

## How an animated email countdown works

Email clients don't run JavaScript, so a countdown in an email has to be an image. Email Countdowns hosts one GIF per deadline at a fixed URL, for example `https://emailcountdowns.com/countdown/public/123.gif`. Every time someone opens the email, their mail client requests that URL and the server draws a fresh animated GIF from the time left at that moment. Someone who opens the email on Monday sees four days to go. Someone who opens the same email on Friday morning sees eight hours.

That is why the image must stay hosted. If you download the GIF and upload it to your email platform's image library, you get a copy frozen at the moment you downloaded it.

The embed code is a single `<img>` tag:

```html
<img src="https://emailcountdowns.com/countdown/public/123.gif" alt="Winter sale ends" width="300" style="max-width:100%;border:0;display:block;" />
```

It works in Gmail, Apple Mail, Outlook, Yahoo and every email platform that lets you add an image by URL or paste HTML. Outlook desktop on Windows shows only the first frame of a GIF. That frame still shows the correct time left when the email was opened.

## Install

You need a free Email Countdowns workspace. The skill walks you through it, or you can [register now](https://emailcountdowns.com/register). It needs no card and includes 1,000 countdown views a month.

### Claude (claude.ai and desktop)

1. Download [`email-countdowns.zip`](https://github.com/nexasoftltd/email-countdowns-skill/raw/main/email-countdowns.zip).
2. Open Settings → Capabilities → Skills, choose Upload skill and pick the zip.
3. Add the countdown connector: Settings → Connectors → Add custom connector. Name it `Email Countdowns` and use the URL `https://emailcountdowns.com/mcp/countdowns`. Select Connect, sign in and approve.

You can skip step 3. The skill will notice the connector is missing and walk you through it.

### Claude Code

Install the plugin. It brings the skill and the MCP server together:

```
/plugin marketplace add nexasoftltd/email-countdowns-skill
/plugin install email-countdowns@email-countdowns
```

Run `/mcp`, pick `email-countdowns` and sign in. To install the skill alone, copy `skills/email-countdowns` into `~/.claude/skills/`.

### ChatGPT

1. Download [`email-countdowns.zip`](https://github.com/nexasoftltd/email-countdowns-skill/raw/main/email-countdowns.zip) and upload it as a skill, if skills are available on your plan.
2. Connect the countdown server: Settings → Apps → Advanced settings, turn on developer mode, then Create app. Name it `Email Countdowns`, use `https://emailcountdowns.com/mcp/countdowns` and choose OAuth. Connect and approve, then pick the app from the tools menu in a new chat.

If your plan or workspace doesn't allow custom apps, build a Custom GPT instead. See [Custom GPTs](#custom-gpt).

### Codex CLI

```
codex mcp add email-countdowns --url https://emailcountdowns.com/mcp/countdowns
codex mcp login email-countdowns
```

Copy `skills/email-countdowns` into your Codex skills folder (`~/.codex/skills/`).

### Gemini CLI and other MCP clients

Any client that supports remote MCP servers over HTTP with OAuth can connect to `https://emailcountdowns.com/mcp/countdowns`. For Gemini CLI:

```
gemini mcp add --transport http countdowns https://emailcountdowns.com/mcp/countdowns
```

Then run `/mcp auth countdowns` inside Gemini CLI. Point the client at `skills/email-countdowns/SKILL.md` as context, or paste it into your project instructions.

## Create your first countdown

Once installed, ask for a countdown in plain language. Include the deadline and timezone if you know them:

> Create an email countdown for our Black Friday sale. It ends 27 November at 23:59 New York time. Make the background #111111 with white numbers.

The agent will:

1. Check it can reach Email Countdowns, and help you sign up and connect if it can't.
2. Pin down the deadline. "Midnight Friday" gets a question (start of Friday or end?), "EST" becomes `America/New_York`, and a deadline already in the past gets caught before anything is created.
3. Confirm the deadline back to you in one line.
4. Create the timer with a campaign key such as `black-friday-2026`. If the request is retried, the same key returns the same timer instead of a duplicate.
5. Return the embed HTML and image URL, and place them in your draft if it can edit your email platform.
6. Add a plain-text line with the deadline for readers who block images.

It won't send or schedule your campaign. That stays with you.

### Styles and colours

Each timer has a text colour, a background colour (any hex value or `transparent`), one of five styles (Classic, Circle, Labelled, Circular progress, Flip clock) and a choice of around 30 fonts. The agent sets the colours from your request. To pick a style or font, open the editor in your [dashboard](https://emailcountdowns.com/dashboard) and give the agent the ID, or change it there afterwards. The image URL never changes, so edits reach emails you have already sent.

### Check how many people saw it

> How many countdown views did we get in the last 7 days?

The agent calls `get-countdown-stats` and reports views per day for your workspace. A view is one request for the image. Apple Mail Privacy Protection and Gmail's image proxy can fetch or cache images, so views are not the same as unique opens.

## Add the countdown to Klaviyo, Mailchimp and other platforms

The agent can paste the timer into a draft when your email platform is connected too, for example through the Klaviyo or Resend MCP servers. Otherwise it hands you the code with these instructions:

| Platform | Where to put the countdown | Step-by-step guide |
|---|---|---|
| Klaviyo | Image block → Image URL, paste the GIF URL | [Klaviyo countdown timers](https://emailcountdowns.com/knowledge/how-to-add-countdown-timers-in-klaviyo) |
| Mailchimp | Image block → Image URL, paste the GIF URL | [Mailchimp countdown timers](https://emailcountdowns.com/knowledge/how-to-add-countdown-timers-in-mailchimp) |
| HubSpot | Image module → Image URL | [HubSpot countdown timers](https://emailcountdowns.com/knowledge/how-to-add-countdown-timers-in-hubspot) |
| Campaign Monitor | Image button, paste the GIF URL | [Campaign Monitor countdown timers](https://emailcountdowns.com/knowledge/how-to-add-countdown-timers-in-campaign-monitor) |
| Salesforce Marketing Cloud | HTML view, paste the embed HTML | [Salesforce countdown timers](https://emailcountdowns.com/knowledge/how-to-add-countdown-timers-in-salesforce) |
| Kit (ConvertKit) | HTML button, paste the embed HTML | [Kit countdown timers](https://emailcountdowns.com/knowledge/how-to-add-countdown-timers-in-convertkit) |
| GetResponse | Source button, paste the embed HTML | [GetResponse countdown timers](https://emailcountdowns.com/knowledge/how-to-add-countdown-timers-in-getresponse) |
| Flodesk | HTML button, paste the embed HTML | [Flodesk countdown timers](https://emailcountdowns.com/knowledge/how-to-add-countdown-timers-in-flodesk) |
| Resend | Put the embed HTML in the broadcast `html` | [Resend broadcasts with AI](https://emailcountdowns.com/knowledge/automate-countdowns-in-resend-broadcasts-with-ai) |
| Any HTML email | Paste the embed HTML into the content column | [Countdowns in any email](https://emailcountdowns.com/knowledge/how-to-add-a-countdown-to-emails) |

For a fully automated Klaviyo flow, read [Automate countdowns in Klaviyo campaigns with AI](https://emailcountdowns.com/knowledge/automate-countdowns-in-klaviyo-campaigns-with-ai).

## Use it without MCP: REST API and Custom GPTs

### REST API

Create a key under Team API key on your [workspace page](https://emailcountdowns.com/workspace) and keep it in an environment variable.

```sh
curl -X POST 'https://emailcountdowns.com/api/countdowns' \
  -H "Authorization: Bearer $COUNTDOWN_API_KEY" \
  -H 'Accept: application/json' -H 'Content-Type: application/json' \
  -d '{"campaign_key":"winter-sale-2026","name":"Winter sale ends","date":"2026-12-18","time":"17:00","timezone":"Europe/London"}'
```

The response holds `data.gif_url` and `data.embed_html`. Endpoints for listing, updating and deleting timers, plus Python and Node examples, are in [`skills/email-countdowns/references/rest-api.md`](skills/email-countdowns/references/rest-api.md).

### Custom GPT

1. In ChatGPT, create a GPT and paste [`chatgpt/gpt-instructions.md`](chatgpt/gpt-instructions.md) into Instructions.
2. Add an action and import [`chatgpt/openapi.yaml`](chatgpt/openapi.yaml).
3. Set authentication to API key, type Bearer, and paste your workspace key.

The GPT can create timers, list them, move a deadline and fetch embed code. It cannot delete timers.

## FAQ

### How do I create an animated countdown timer for an email?

Create a countdown on a service that generates the GIF when the email is opened, then add its image URL or `<img>` tag to your email. With this skill installed, ask your agent for a countdown with a date, time and timezone and it returns the code. Without an agent, use the [Email Countdowns dashboard](https://emailcountdowns.com/dashboard).

### Will the countdown keep ticking after the email is sent?

Each open shows the time left at that moment. The GIF then counts down 30 seconds and loops, so it never drifts far from the true time. Reopening the email fetches a fresh image.

### What happens when the deadline passes?

The timer shows zero. Leave it in place, because deleting a timer breaks the image in every email that has already gone out.

### Can I change the deadline after sending?

Yes. Move it through the dashboard or the API and every email already sent shows the new deadline on its next open, because the URL stays the same.

### Does it work in Gmail and Outlook?

Gmail, Apple Mail, Yahoo and Outlook on the web and mobile play the animation. Outlook desktop on Windows shows the first frame, which still has the correct time left.

### What does it cost?

Signing up is free and needs no card, and the free allowance is 1,000 countdown views a month. Current rates are on the [pricing page](https://emailcountdowns.com/pricing).

### Is my data safe with the agent?

The MCP connection uses OAuth. You approve it in your browser and it covers the workspace you had active at the time. The skill never asks for your password. API keys can be revoked on your [workspace page](https://emailcountdowns.com/workspace). Through MCP the agent can create timers and read statistics, but it can't edit or delete existing timers.

## Repository layout

```
skills/email-countdowns/SKILL.md          the skill
skills/email-countdowns/references/       REST API and email platform details
chatgpt/                                  Custom GPT instructions and OpenAPI action schema
.claude-plugin/                           Claude Code plugin and marketplace manifests
.mcp.json                                 MCP server config used by the plugin
email-countdowns.zip                      skill packaged for upload
scripts/build-zip.sh                      rebuilds the zip after editing the skill
```

## Support

Questions or problems: [emailcountdowns.com/contact](https://emailcountdowns.com/contact) or open an issue on this repository.

MIT licensed. Made by [Nexasoft Ltd](https://nexasoftltd.com).
