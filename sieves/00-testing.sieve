require ["fileinto", "extlists", "vnd.proton.expire"];

# This sieve is useful for testing.
# Create a contact group and name it "Self".
# Add your personal e-mail addresses to this group.
# You can alternatively use ":addrbook:myself"
# but I prefer to test with external addresses.
if header :list "from" ":addrbook:personal?label=Self"
{
    fileinto "Activity Stream";  # folder
    fileinto "VIP";  # label
    expire "minute" "22";
}

# TODO: Review for ideas https://www.reddit.com/r/ProtonMail/comments/xkypkp/golden_sieve/
