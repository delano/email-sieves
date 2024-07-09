require ["include", "environment", "variables", "relational", "comparator-i;ascii-numeric", "spamtest"];
require ["fileinto", "imap4flags", "extlists"];

# Generated: Do not run this script on spam messages
if allof (environment :matches "vnd.proton.spam-threshold" "*", spamtest :value "ge" :comparator "i;ascii-numeric" "${1}") {
    return;
}

/**
 * @type and
 * @comparator contains
 * @comparator !contains
 */
if allof (header :list "to" ":addrbook:personal?label=VIPs", not address :all :comparator "i;unicode-casemap" :contains "From" ["Delbo", "Delano"]) {

    fileinto "Inbox";
    fileinto "VIP";

    keep;
    stop;
}
