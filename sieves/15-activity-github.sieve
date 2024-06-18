require ["fileinto", "imap4flags", "vnd.proton.expire", "extlists"];

# Move Github notifications to the Activity folder
# and label them with the Github label.

# When a github notification sender is seen for the first time,
# We can't simply create a new contact for <notifications@github.com>
# b/c the name of that contact will override the name of the
# github user in the From header (very confusing when browsing the inbox).
if address :matches "from" "notifications@github.com"
{
    fileinto "Activity"; # folder
    fileinto "Github";   # label
    expire "day" "7";
    stop;
}
