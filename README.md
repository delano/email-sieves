# Email Sieve Filters

My personal sieve filters for use with [ProtonMail](https://protonmail.com/).
Sieves are commonly referred to as email filters.

While these are personal sieves, most of these are general purpose and can be modified/extended as needed.

Contributions are accepted.

## Design Philosophy

- When in doubt, default to expiring emails. Few things truly need to be kept indefinitely.
  - As of 03-18-2021, ProtonMail supports an undocumented maximum expiration of 120 days. Setting a value greater than 120 days will be silently accepted with no server side errors, defaulting to the max of 120 days. Keep this in mind.
  - Avoid using a global expiration rule with an "opt-in" model for retention. Emails are too unpredictable - it's a delicate balance.
  - Biannual offsite backups should address what concerns may arise from this strategy.
- Scheduled/routine emails of importance (example - daily finance updates) should route to the main inbox, but expire quickly.
- Keep it simple and avoid having too many folders and labels.
  - A doctors appointment email and a restaurant reservation email can go to the same folder, and that's okay.
- No organizatonal system will ever be perfect. Expect _and_ accept occasional inefficiencies.
- Think carefully about the execution chain. Use stops when warranted.
- Use subject header parsing with caution, but don't be afraid. It's an immensely powerful routing mechanism.
- IMAP uses [modified UTF-7](https://tools.ietf.org/html/rfc5228#section-2.1). Ensure folder and label names are in the [US-ASCII](https://www.charset.org/charsets/us-ascii) range.
- You can only test so much before going to "prod". Ensure sieves handling ~critical emails explicitly check for _and_ resolve unintended states, such as expirations.
- Btw, ProtonMail doesn't support the full capabilities of sieve. So using any guide on the web most likely won't work. They have a pretty good guide on their own, though: https://protonmail.com/support/knowledge-base/sieve/


## Useful Links

- [ProtonMail Sieve Docs](https://protonmail.com/support/knowledge-base/sieve-advanced-custom-filters/)
- [Sieve Tutorial](https://p5r.uk/blog/2011/sieve-tutorial.html)
- [Official Sieve Wiki](http://sieve.info/)
- [Sieve Language RFC](https://tools.ietf.org/html/rfc5228)
- [IMAP RFC](https://tools.ietf.org/html/rfc3501)

## Testing

- [Web app for testing sieves](https://www.fastmail.com/cgi-bin/sievetest.pl)
  - NOTE - ensure NO personaly identifiable information is pasted into this tool.
  - Pro Tip - this app is not aware of the "vnd.proton.expire" package. Remove it when testing with this app.
- When adding the sieve to ProtonMail, basic linting is performed server-side.

## Deployment

- Manually copy and paste the definitions into [ProtonMail Filters](https://beta.protonmail.com/u/0/settings/filters#custom)
  - "Ads" sieve is executed 1st (00)
  - "Security" sieve is executed 2nd (01)
  - "Statements" sieve is executed 3rd (02)
  - "Orders and Shipping" sieve is executed last (zz)

## To Do

- Improve local testing by hooking up [sieve script editor](https://github.com/thsmi/sieve) to [docker-mailserver](https://github.com/docker-mailserver/docker-mailserver/wiki/Configure-Sieve-filters) [local dev]
- Add Travis PR tests which check for syntax errors [CI]
  - Can likey have Travis run [docker-mailserver](https://github.com/docker-mailserver/docker-mailserver/wiki/Configure-Sieve-filters) and load the sieve filters into memory. Needs further investigation.
- Create test suite with mock email data (CI)
- Automate deployments [CD]
  - This is high LOE and has significant security implications.
