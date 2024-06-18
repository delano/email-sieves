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
    "verify", "verification", "magic link", "magic login", "magic sign-in",
    "confirm your email", "link to log in", "log-in link", "login link",
    "sign-in link", "signin link", "click here to login",
    "click here to sign in", "continue signing in", "continue logging in"
]
{
    # If the email is a reply or forward from a person, we don't want to
    # file it as an action email. We treat it as a regular email and let
    # the email through to further sieve processing.
    if anyof (header :matches "subject" "Re:*",
              header :matches "subject" "Fwd:*",
              header :matches "subject" "FYI:*") {
        return;
    }

    # Flag as an action email at this point. But we may take further
    # action based on a more specific subject.
    fileinto "Autoresponse";  # label
    fileinto "Action Emails";  # label

    #
    if header :contains "subject" [
        "your appointment", "your booking", "your reservation",
        "reminder"
    ]
    {
        # Emails that are about things coming up in the future, such as
        # appointments, bookings, or reservations, should be kept for a
        # longer period of time.
        expire "day" "14";
    }
    else
    {
        # Emails that are part of a workflow, such as a password reset,
        # only need to be kept for a shorter period of time.
        expire "hour" "24";
    }

    # Action emails don't need any more processing.
    stop;
}
