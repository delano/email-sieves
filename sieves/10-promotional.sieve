require ["fileinto", "imap4flags", "vnd.proton.expire"];

# Check promotoinal messages by precendence header
if allof (
    anyof (
        header :contains "precedence" ["bulk", "junk"]
    )
)
{
    fileinto "Junk";  # folder
    fileinto "Promotional";  # label

    # Filing into Activity Stream but expired quickly. May want to
    # make FYI a folder and move there instead (to keep it out of
    # the inbox but not delete it immediately).
    expire "day" "7";

    # It's self-proclaimed junk. No need to spend any more time on it.
    stop;
}
