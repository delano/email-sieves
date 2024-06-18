require ["fileinto", "include", "variables", "vnd.proton.expire"];

# NOTE: How to extend i18n? Might be straightforward enough to simply
# have full separate translation. But, we might want to have a more
# flexible system that allows for partial translations, or even
# translations that are not 1:1. For example, "security alert" might
# be translated to "sicherheitswarnung" in German, but "security
# notification" might be translated to "sicherheitsbenachrichtigung".

# This sieve is high up in the execution chain, as we want to
# short-circuit these from other sieves and centralize all
# action emails.

# Common subjects relevant to action events
# NOTE: How to extend i18n?
if header :contains "subject" [
    "security alert", "security notification", "login", "sign-on",
    "sign-in", "sign in", "sign on", "email address", "email change",
    "password", "account alert", "account activity", "account security",
    "verify", "verification",
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
