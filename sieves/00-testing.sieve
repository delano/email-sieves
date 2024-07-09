# 00-testing.sieve
require ["fileinto", "imap4flags", "vnd.proton.expire", "extlists"];
require ["comparator-i;ascii-numeric", "spamtest", "relational", "imap4flags"];
require ["variables", "envelope", "regex"];

# 12-service-specific-addresses.sieve

# This script is an example of how to use Sieve to handle messages based on
# the sender's domain and the local part of the recipient's address.
#
# Sender: noreply@sourgrapes.com
# To: sourgrapes@example.com
#
# Links:
# - https://www.reddit.com/r/fastmail/comments/pjr3u8/help_sieve_how_to_dynamically_filtersort_emails/hbye6rj/
# - https://explained-from-first-principles.com/email/#mail-filtering-language (RFC 5228)
# - https://explained-from-first-principles.com/email/#filter-management-protocol (RFC 5804)
# - https://proton.me/support/sieve-advanced-custom-filters

# In Sieve, when using the split function and accessing the resulting list,
# the indexing typically starts at 1, not 0. This is different from many
# programming languages where array indexing starts at 0.
#
#
# domain_parts.1 would be the first element (leftmost part of the domain)
# domain_parts.2 would be the second element, etc...
#
# For example, if the domain is "www.sourgrapes.com":
#
#   domain_parts.1 would be "www"
#   domain_parts.2 would be "sourgrapes"
#   domain_parts.3 would be "com"


# Extract the domain from the sender address
set "sender_domain" "${address.domain}";

if header :matches "from" "*@*" {
    # The first * matches "noreply", the second "sourgrapes.com".
    set "from_local" "${1}";
    set "from_domain" "${2}";
}

# For debugging, set the domain parts as headers
#addheader "X-From-Local" "${from_local}";
#addheader "X-From-Domain" "${from_domain}";

# Extract the local part from the To address
if envelope :matches "to" "*@*" {
    set "local_part" "${1}";
    set "local_part_length" "${length:${local_part}}";

     # Optional: For debugging, you can use these lines to see the values:
     # fileinto "Debug";
     #addheader "X-Local-Part" "${local_part}";
     #addheader "X-Local-Part-Length" "${local_part_length}";

     # Now you can use ${local_part} and ${local_part_length} in your script
     #
     if allof (
         anyof (string :contains "${from_domain}" "${local_part}"),
         anyof (string :value "ge" "${local_part_length}" "5")
     ) {

         # Do something when local part matches the domain part.
         fileinto "Sievey Nicks";

     } else {
        # At this point in the script, the message should be delivered to the
        # default mailbox without any special handling or redirection. without
        # applying any further filtering actions defined in the script.
        #
        # The keep action is useful in scenarios where you want to ensure that
        # an email passes through the filtering process without being
        # redirected or filed into a specific folder based on the conditions
        # tested before the keep action.
        #keep;
     }
}
