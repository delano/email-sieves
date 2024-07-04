require ["include", "environment", "variables", "relational", "comparator-i;ascii-numeric", "spamtest"];
require ["fileinto", "imap4flags", "vnd.proton.expire"];

# Generated: Do not run this script on spam messages
if allof (environment :matches "vnd.proton.spam-threshold" "*", spamtest :value "ge" :comparator "i;ascii-numeric" "${1}") {
    return;
}

/**
 * @type and
 * @comparator is
 * @comparator !contains
 */
if allof (address :all :comparator "i;unicode-casemap" :is "From" ["auto-confirm@amazon.ca", "no-reply@amazon.ca", "shipment-tracking@amazon.ca"], not header :comparator "i;unicode-casemap" :contains "Subject" ["AWS", "EC2", "S3", "Route53", "SES", "CloudWatch", "ELB", "ALB", "NLB", "DNS", "Support", "Request"]) {
    fileinto "Service Events";
    fileinto "Service";

    expire "day" "90";

}
