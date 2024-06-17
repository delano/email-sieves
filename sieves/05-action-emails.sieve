require ["fileinto", "imap4flags", "vnd.proton.expire"];

# This sieve is high up in the execution chain, as we want to
# short-circuit these from other sieves and centralize all
# security events.

# Common subjects relevant to security events
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
    fileinto "Action Emails";
    expire "hour" "12";
    stop;
}
