require ["fileinto", "imap4flags", "vnd.proton.expire"];

# Enhanced check for mailing list messages
# Checks for "List-Id", "List-Post", and "Precedence" headers.
#
# Does not check for "List-Unsubscribe" header because it can be
# present in transactional emails and other messages that are not
# mailing list messages. e.g. "[Fly.io] Password setup instructions"
if anyof (
    exists "list-id",
    exists "list-post",
    header :contains "precedence" ["list"])  # used to include "bulk", "junk"
{
    fileinto "Activity Stream";  # folder
    fileinto "MailingList";  # label

    expire "day" "14";
}

# Continue executing other sieve scripts
