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
# Junk
# Auth-Issue-DMARC
# Auth-Issue-SPF
# Auth-Issue-ARC
# Auth-Issue-DKIM
#
# Many legitimate services still fail domain checks. Quarantine
# matching messages to the Junk folder but keep them for a week
# for review.

# Generated: Do not run this script on spam messages
if allof (environment :matches "vnd.proton.spam-threshold" "*", spamtest :value "ge" :comparator "i;ascii-numeric" "${1}") {
    return;
}


# DMARC (Domain-based Message Authentication, Reporting, and Conformance) check
# Failure indicates the email failed alignment with SPF or DKIM policies set by the sender's domain
if header :regex "Authentication-Results" "mail\.protonmail\.ch;.*dmarc=(fail|none).*" {
    fileinto "Junk"; # Move to Junk folder
    fileinto "Auth-Issue-DMARC"; # Apply DMARC issue label
    setflag "\\Flagged"; # Flag the message

    expire "day" "7";
}

# SPF (Sender Policy Framework) check
# Failure suggests the sending server is not authorized to send mail for the stated domain
if header :regex "Authentication-Results" "mail\.protonmail\.ch;.*spf=(fail|none).*" {
    fileinto "Junk"; # Move to Junk folder
    fileinto "Auth-Issue-SPF"; # Apply SPF issue label
    setflag "\\Flagged"; # Flag the message

    expire "day" "7";
}

# ARC (Authenticated Received Chain) check
# Failure or absence may indicate issues with email forwarding or mailing lists
if header :regex "Authentication-Results" "mail\.protonmail\.ch;.*arc=(fail|none).*" {
    fileinto "Junk"; # Move to Junk folder
    fileinto "Auth-Issue-ARC"; # Apply ARC issue label
    setflag "\\Flagged"; # Flag the message

    expire "day" "7";
}

# DKIM (DomainKeys Identified Mail) check
# Failure suggests the email content may have been altered in transit or the sender is not authorized
if header :regex "Authe
ntication-Results" "mail\.protonmail\.ch;.*dkim=(fail|none).*" {
    fileinto "Junk"; # folder
    fileinto "Auth-Issue-DKIM"; # label
    setflag "\\Flagged";

    expire "day" "7";
}
