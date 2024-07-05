require ["fileinto", "imap4flags", "vnd.proton.expire"];
require ["include", "environment", "variables", "relational", "comparator-i;ascii-numeric", "spamtest"];

# Generated: Do not run this script on spam messages
if allof (environment :matches "vnd.proton.spam-threshold" "*", spamtest :value "ge" :comparator "i;ascii-numeric" "${1}") {
    return;
}


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
    addflag "\\Seen";
    stop;
}



if anyof (header :comparator "i;unicode-casemap" :contains "Subject" ["free months", "cancel anytime", "promo", "Winter sale", "Spring sale", "for Spring", "Summer sale", "for Summer", "on Now", "Limited time", "for Winter", "for Fall", "Fall sale", "for Autumn", "Autumn sale", "for free", "Costco Wholesale", "Costco.ca", "VMWare", "Unstoppable domains", "Unstoppable", "Bed Bath", "Bed, Bath", "Costco Warehouse", "Bed Bath", "Bed, Bath", "Bath & Beyond"], address :all :comparator "i;unicode-casemap" :contains "From" ["CostcoNews@digital.costco.ca", "info@gravitypope.com", "promotion.bedbathandbeyond.com", "Bed Bath", "Bath & Beyond", "email@promotion.bedbathandbeyond.com", "Kevin from Synthesia", "rewards@c.pxsmail.com"]) {
    fileinto "Junk";
    fileinto "Promotional";

    expire "day" "7";

    addflag "\\Seen";
    stop;
}
