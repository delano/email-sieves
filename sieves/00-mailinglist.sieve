require ["fileinto", "imap4flags"];


# If "list-unsubscribe" header present, flag for easy manual review
# MailingList is a label, NOT a folder
if exists "list-unsubscribe"
{
    fileinto "MailingList";
}

# do NOT stop executing, allow other sieves to continue processing
