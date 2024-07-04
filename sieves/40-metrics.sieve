require ["include", "environment", "variables", "relational", "comparator-i;ascii-numeric", "spamtest"];
require ["fileinto", "imap4flags", "vnd.proton.expire"];

# Generated: Do not run this script on spam messages
if allof (environment :matches "vnd.proton.spam-threshold" "*", spamtest :value "ge" :comparator "i;ascii-numeric" "${1}") {
    return;
}

/**
 * @type and
 * @comparator starts
 */
if allof (header :comparator "i;unicode-casemap" :matches "Subject" "[stathat]*") {

    fileinto "Permanent Record";  # folder
    fileinto "Metrics";  # label
    fileinto "To: Onetime";  # label

    expire "day" "90";
}
