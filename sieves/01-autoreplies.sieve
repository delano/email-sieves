require ["fileinto", "extlists", "vnd.proton.expire"];
require ["include", "environment", "variables", "relational", "comparator-i;ascii-numeric", "spamtest"];

# This script filters out messages that are indicative of autoreplies
# and takes appropriate actions. Specifically looks for the X-Autoreply
# header, the Auto-Submitted header, and common autoreply indicators in
# the Subject header.

# TODO: How to store the confidence level of the autoreply detection?

# Prevent processing of messages that meet the spam threshold.
if allof (environment :matches "vnd.proton.spam-threshold" "*", spamtest :value "ge" :comparator "i;ascii-numeric" "${1}") {
    return;
}


if anyof (header :list "to" ":addrbook:myself",
          header :list "to" ":addrbook:personal?label=Self") {

    # Check for the non-standard X-Autoreply header indicating an autoreply.
    # If present, the message is filed into the "Autoreply" folder and processing stops.
    if header :contains "X-Autoreply" "yes"
    {
        fileinto "Autoreply";  # label
        # addheader "X-Autoreply-Confidence" "0";
        expire "day" "7";
        stop;
    }

    # Check for the standard Auto-Submitted header set to auto-replied, indicating an automatic response.
    # Matches are also filed into the "Autoreply" folder and processing is halted.
    if header :contains "Auto-Submitted" "auto-replied"
    {
        fileinto "Autoreply";  # label
        # addheader "X-Autoreply-Confidence" "1";
        expire "day" "7";
        stop;
    }

    # Additional check for common autoreply indicators in the Subject header and if the recipient is the user.
    # Matches are filed into "Autoreply" and set to expire in 7 days.
    # if allof (
    #     header :comparator "i;unicode-casemap" :matches "Subject" [
    #         "Undeliverable", "Undelivered", "Delivery Status", "Auto reply", "Automatic response",
    #         "Réponse automatique", "Vacation", "complaint about message from", "Comcast Abuse Report",
    #         "Delivery Status Notification", "FW:Verify", "FW: Verify", "Ihre Nachricht",
    #         "Automatic reply", "Rejected", "Returned mail", "Re: verify", "re: verif", "Re: Vérifier",
    #         "Automatisch antwoord", "Your message couldn't be delivered", "Out of Office",
    #         "Automatische Antwort", "Erro de entrega", "I'm away", "Out of the office",
    #         "I'll be away", "I'll be out of the office", "I'll be on vacation", "I'll be out of town"],
    #     header :list "to" ":addrbook:myself") {
    #
    #     fileinto "Autoreply";
    #     addheader "X-Autoreply-Confidence" "-1";
    # }

}
