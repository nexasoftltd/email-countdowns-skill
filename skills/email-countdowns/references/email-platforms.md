# Placing the countdown in each email platform

Every platform accepts the timer in one of two ways:

- **HTML:** paste `embed_html` into a custom HTML / code block, or into the template source.
- **Image by URL:** add an image block, choose the Image URL / external URL option and paste `gif_url`. Do not download the GIF and upload it as a file; an uploaded copy is frozen.

When you edit a draft through another connected tool, read the draft first, change only the countdown slot, save, then read it back and check the image `src` still equals `gif_url`. Never send or schedule the campaign yourself.

| Platform | Where it goes | Guide |
|---|---|---|
| Klaviyo | Image block → Image URL, paste `gif_url`, set alt text. In code templates, paste `embed_html` into the HTML. | https://emailcountdowns.com/knowledge/how-to-add-countdown-timers-in-klaviyo |
| Mailchimp | Image block → Image URL, paste `gif_url`. Through the Marketing API, read `GET /campaigns/{id}/content`, replace only the countdown slot in the HTML, write it back with `PUT /campaigns/{id}/content`. | https://emailcountdowns.com/knowledge/how-to-add-countdown-timers-in-mailchimp |
| Resend | Put `embed_html` in the broadcast or email `html`. With the Resend MCP server, update the draft broadcast, then retrieve it and check the `src`. | https://emailcountdowns.com/knowledge/automate-countdowns-in-resend-broadcasts-with-ai |
| HubSpot | Image module → Image URL, paste `gif_url`, set alt text. | https://emailcountdowns.com/knowledge/how-to-add-countdown-timers-in-hubspot |
| Campaign Monitor | Image button in the editor, paste `gif_url`, add alt text, Insert. | https://emailcountdowns.com/knowledge/how-to-add-countdown-timers-in-campaign-monitor |
| Salesforce Marketing Cloud | Switch to HTML view and paste `embed_html`. | https://emailcountdowns.com/knowledge/how-to-add-countdown-timers-in-salesforce |
| Kit (ConvertKit) | HTML button in the editor, paste `embed_html`. | https://emailcountdowns.com/knowledge/how-to-add-countdown-timers-in-convertkit |
| GetResponse | Source button in the editor, paste `embed_html`. | https://emailcountdowns.com/knowledge/how-to-add-countdown-timers-in-getresponse |
| Flodesk | HTML button in the editor, paste `embed_html`. | https://emailcountdowns.com/knowledge/how-to-add-countdown-timers-in-flodesk |
| Hand-written or generated HTML | Insert `embed_html` in the content column. Use inline styles; some clients drop `<style>` blocks. | https://emailcountdowns.com/knowledge/how-to-add-a-countdown-to-emails |

Automated Klaviyo campaigns with an agent: https://emailcountdowns.com/knowledge/automate-countdowns-in-klaviyo-campaigns-with-ai

## A complete block

```html
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td align="center" style="padding:16px 0;">
      <a href="https://example.com/sale">
        <img src="https://emailcountdowns.com/countdown/public/123.gif" alt="Winter sale ends" width="300" style="max-width:100%;border:0;display:block;" />
      </a>
      <p style="margin:8px 0 0;font:14px/1.4 Arial,sans-serif;color:#444;">Sale ends 18 December at 5pm UK time.</p>
    </td>
  </tr>
</table>
```

## Checks before handing the draft back

- The `src` is the hosted `gif_url`, unchanged.
- The deadline in the copy matches the timer, timezone included.
- `alt` text describes the deadline.
- The plain-text fallback line is present.
- Send a test to yourself and open it. Outlook desktop on Windows shows only the first frame of a GIF, which still shows the correct time left.
