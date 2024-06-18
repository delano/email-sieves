require ["fileinto", "include", "vnd.proton.expire"];

# This sieve is high up in the execution chain, as we want to
# short-circuit these from other sieves and centralize all
# action emails.

# Common subjects relevant to action events
# NOTE: How to extend i18n?
if header :contains "subject" [
    "security alert", "security notification", "login", "sign-on",
    "sign-in", "sign in", "sign on", "email address", "email change",
    "password", "account alert", "account activity", "account security",
    "verify", "verification", "confirmation", "confirm",
    "confirm your email", "link to log in", "log-in link", "login link",
    "sign-in link", "signin link", "click here to login",
    "click here to sign in", "continue signing in", "continue logging in"
]
{
    if anyof (header :matches "subject" "Re:*",
              header :matches "subject" "Fwd:*",
              header :matches "subject" "FYI:*") {
        # If the subject is a reply, we don't want to file it
        # as an action email. Treat it as a regular email; let
        # the sieve chain continue.
        return;
    }

    fileinto "Action Emails";
    expire "hour" "12";
    stop;
}
