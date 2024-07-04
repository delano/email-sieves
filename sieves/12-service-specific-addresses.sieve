# 12-service-specific-addresses.sieve
require ["fileinto", "imap4flags", "vnd.proton.expire", "extlists"];
require ["variables", "comparator-i;ascii-casemap", "spamtest", "relational", "imap4flags"];
require ["variables", "envelope", "regex", "comparator-i;ascii-casemap"];

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

# Split the domain into parts
set "domain_parts" "${split}", ".", "${sender_domain}";

# Get the number of parts
set "num_parts" "${num_variables}";

# For debugging, set the domain parts as headers
addheader "X-Domain-Parts" "${domain_parts}";
addheader "X-Domain-Parts-Num" "${num_parts}";
addheader "X-Domain-Parts-1" "${domain_parts.1}";
addheader "X-Domain-Parts-2" "${domain_parts.2}";
addheader "X-Domain-Parts-3" "${domain_parts.3}";

# Extract the local part from the To address
if envelope :matches "to" "*@*" {
    set "local_part" "${1}";
    set "local_part_length" "${length:${local_part}}";

    # Optional: For debugging, you can use these lines to see the values:
    # fileinto "Debug";
     addheader "X-Local-Part" "${local_part}";
     addheader "X-Local-Part-Length" "${local_part_length}";

     # Now you can use ${local_part} and ${local_part_length} in your script
     if allof (
         :is "${local_part}" ${domain_parts.1},
         :value "ge" "${local_part_length}" "5"
     ) {

         # Do something when local part matches the domain part.
         fileinto "Sievey Nicks";

     } else {
        # At this point in the script, the message should be delivered to the
        # default mailbox without any special handling or redirection.
         keep;
     }
}
