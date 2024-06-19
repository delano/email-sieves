require ["fileinto", "include", "variables", "vnd.proton.expire"];

# Action Emails are emails that require some kind of action from the
# recipient. Unlike other automatic emails, we don't filter by our
# own email addresses here, as we want to catch all action emails
# regardless of what email address they are sent to. For example,
# creating accounts with unique email addresses for each service
# you sign up for. Or privacy protected email aliases. Or even
# emails sent to a group email address.

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
#
# TODO: This list is not exhaustive, and isn't meant to be. It's
# meant to be a starting point. We can add more subjects as we go
# along. We can also add more complex rules, such as checking for
# specific sender addresses, or checking for specific keywords in
# the email body.

if header :contains "subject" [
    "security alert", "security notification", "login", "sign-on",
    "sign-in", "sign in", "sign-in link", "signin link", "sign on",
    "confirm your email", "confirm your account", "confirm your identity",
    "password reset", "password recovery", "password change",
    "account alert", "account activity", "account security",
    "verification", "verify your",
    "magic link", "magic login", "magic sign-in",
    "link to log in", "log-in link", "login link",
    "click here to login", "click here to sign in",
    "continue signing in", "continue logging in"
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
    # Set the expiration time for the email.
    #

    # Emails that are about things coming up in the future, such as
    # appointments, bookings, or reservations, should be kept for a
    # longer period of time.
    if header :contains "subject" [
        "your appointment", "your booking", "your reservation",
        "reminder"
    ]
    {
        expire "day" "14";
    }

    # Emails that are part of a workflow, such as a password reset,
    # only need to be kept for a shorter period of time.
    else
    {
        expire "hour" "24";
    }

    # Action emails don't need any more processing.
    stop;
}
