require ["fileinto", "imap4flags", "vnd.proton.expire"];

# Enhanced check for mailing list messages
# Checks for "List-Unsubscribe", "List-Id", "List-Post", and "Precedence" headers
if anyof (
    exists "list-unsubscribe",
    exists "list-id",
    exists "list-post",
    header :contains "precedence" ["list", "bulk", "junk"])
{
    fileinto "MailingList";
    expire "day" "365";

    # Optionally, add a flag for manual review
    addflag "\\Flagged";
}

# Continue executing other sieve scripts
