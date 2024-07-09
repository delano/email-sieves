require ["include", "environment", "variables", "relational", "comparator-i;ascii-numeric", "spamtest"];
require ["fileinto", "imap4flags", "vnd.proton.expire", "regex"];

# Examples:
#
# Authentication-Results: mail.protonmail.ch; dmarc=fail (p=quarantine dis=none) header.from=onetimesecret.com
# Authentication-Results: mail.protonmail.ch; spf=fail smtp.mailfrom=onetimesecret.com
# Authentication-Results: mail.protonmail.ch; arc=none smtp.remote-ip=69.174.C.D
# Authentication-Results: mail.protonmail.ch; dkim=none
#

# Relies on the following labels/folders existing in your mailbox setup:
#
# -DMARC
# -SPF
# +ARC
# -DKIM
#
# Many legitimate services still fail domain checks. Don't even quarantine
# matching messages to the Junk folder yet. Don't expire either yet. Flag
# them with the labels and try to use other sieves to filter them out of
# the inbox.

# Generated: Do not run this script on spam messages
if allof (environment :matches "vnd.proton.spam-threshold" "*", spamtest :value "ge" :comparator "i;ascii-numeric" "${1}") {
    return;
}

# DMARC (Domain-based Message Authentication, Reporting, and Conformance) check
# Failure indicates the email failed alignment with SPF or DKIM policies set by the sender's domain
if header :regex "Authentication-Results" "mail\.protonmail\.ch;.*dmarc=(fail|none).*" {
    #fileinto "Inbox"; # temporary, to get out of junk folder
    fileinto "-DMARC"; # Apply DMARC issue label
}

# SPF (Sender Policy Framework) check
# Failure suggests the sending server is not authorized to send mail for the stated domain
if header :regex "Authentication-Results" "mail\.protonmail\.ch;.*spf=(fail|none).*" {
    #fileinto "Inbox"; # Move to Junk folder
    fileinto "-SPF"; # Apply SPF issue label
}

# NOTE: This catches at least an order of magnitude more (otherwise valid)
# emails than DMARC and SPF checks, so it's important not to expire or move
# to Junk based on this alone.
#
# ARC (Authenticated Received Chain) check
# Failure or absence may indicate issues with email forwarding or mailing lists
if header :regex "Authentication-Results" "mail\.protonmail\.ch;.*arc=(fail|none).*" {
    # Do nothing.
    # So many failures... (Summer 2024)
}
if header :regex "Authentication-Results" "mail\.protonmail\.ch;.*arc=(pass).*" {
    fileinto "+ARC";
}

# DKIM (DomainKeys Identified Mail) check
# Failure suggests the email content may have been altered in transit or the sender is not authorized
if header :regex "Authentication-Results" "mail\.protonmail\.ch;.*dkim=(fail|none).*" {
    #fileinto "Inbox"; # folder
    fileinto "-DKIM"; # label
}
