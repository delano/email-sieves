require ["include", "environment", "variables", "relational", "comparator-i;ascii-numeric", "spamtest"];
require ["fileinto", "imap4flags", "extlists", "vnd.proton.expire"];

# Generated: Do not run this script on spam messages
if allof (environment :matches "vnd.proton.spam-threshold" "*", spamtest :value "ge" :comparator "i;ascii-numeric" "${1}") {
    return;
}


if allof (header :list "from" ":addrbook:personal?label=Socials") {

    fileinto "Activity Stream"; # folder
	fileinto "Social"; # label

    expire "day" "7";

    # We've matched a strong condition where the user has explicitly
    # added the sender to the Socials group in their address book.
    # We can stop processing the message now.
    stop;
}
