require ["include", "environment", "variables", "relational", "comparator-i;ascii-numeric", "spamtest"];
require ["fileinto", "imap4flags", "vnd.proton.expire"];

# Generated: Do not run this script on spam messages
if allof (environment :matches "vnd.proton.spam-threshold" "*", spamtest :value "ge" :comparator "i;ascii-numeric" "${1}") {
    return;
}

/**
 * @type and
 * @comparator contains
 */
if allof (address :all :comparator "i;unicode-casemap" :contains ["To", "Cc", "Bcc"] ["dmarc.ruf1@onetimesecret.com", "dmarc.rua1@onetimesecret.com"]) {

    fileinto "Service Events/OPS"; # folder
    fileinto "To: Onetime"; # label
    fileinto "Not-a-human"; # label

    expire "day" "90";
    stop;
}
