require ["fileinto", "extlists", "vnd.proton.expire"];
require ["include", "environment", "variables", "relational", "comparator-i;ascii-numeric", "spamtest"];

# This script filters out messages that are indicative of autoreplies
# and takes appropriate actions. Specifically looks for the X-Autoreply
# header, the Auto-Submitted header, and common autoreply indicators in
# the Subject header.
#
# e.g. VACATION, OUT OF OFFICE, AUTOREPLY, etc.

# TODO: How to store the confidence level of the autoreply detection?

# Prevent processing of messages that meet the spam threshold.
if allof (environment :matches "vnd.proton.spam-threshold" "*", spamtest :value "ge" :comparator "i;ascii-numeric" "${1}") {
    return;
}


if anyof (header :list "to" ":addrbook:myself",
          header :list "to" ":addrbook:personal?label=Self") {


    if allof (

        header "x-auto-response-suppress" ["DR", "OOF", "AutoReply"],
        header "precedence" ["auto_reply"],  # not "bulk" or "list"
        header "auto-submitted" ["auto-replied"],  # not "auto-generated"

        # Check for common autoreply indicators in the Subject header.
        header :comparator "i;unicode-casemap" :matches "Subject" [
            "out of office", "vacation", "on vacation", "on leave", "away from the office",
            "out of the office", "away from my desk",

            # Other languages
            "fuera de la oficina"
        ] )
    {
        fileinto "Autoresponse";  # label
        fileinto "FYI"; # label
        expire "day" "7";
        stop;
    }
}
