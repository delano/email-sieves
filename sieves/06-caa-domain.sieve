require ["include", "environment", "variables", "relational", "comparator-i;ascii-numeric", "spamtest"];
require ["fileinto", "imap4flags", "vnd.proton.expire"];

# Generated: Do not run this script on spam messages
if allof (environment :matches "vnd.proton.spam-threshold" "*", spamtest :value "ge" :comparator "i;ascii-numeric" "${1}") {
    return;
}

/**
 * @type and
 * @comparator is
 */
if allof (address :all :comparator "i;unicode-casemap" :is ["To", "Cc", "Bcc"] "domains@onetimesecret.com") {

    fileinto "Service Events/OPS";
    fileinto "To: Onetime";
    fileinto "Not-a-human";

    expire "day" "90";
    stop;
}
