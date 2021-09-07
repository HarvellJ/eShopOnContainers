# sched_query_rules_alert.auto.tfvars

resourceRegion="eastus"

# SLOs as Code Example 
SLOs = {
    "View Catalog-SuccessRate 2-percent-budget-1hour" = {
        userJourneyCategory = "View Catalog",
        sloCategory         = "ErrorRate",
        sloPercentile       = ""
        sloDescription      = "\"/catalog\" request error rate in the last 360 mins measured at API Gateway with a 13% burn rate",
        signalQuery         = <<-EOT
            AppRequests
                | where Url !contains "localhost" and Url !contains "/hc"
                | extend httpMethod = tostring(split(Name, ' ')[0])
                | where Name contains "Catalog"
                | summarize succeed = count(Success == true), failed = count(Success == false), total=count() by bin(TimeGenerated, 60m)
                | extend AggregatedValue = todouble(failed) * 10000 / todouble(total)
        EOT
        signalSeverity      = 2,
        frequency           = 15,
        time_window         = 60,
        triggerOperator     = "GreaterThanOrEqualTo",
        triggerThreshold    = 130
    },
    "View Catalog-SuccessRate 5-percent-budget-6hours" = {
        userJourneyCategory = "View Catalog",
        sloCategory         = "ErrorRate",
        sloPercentile       = ""
        sloDescription      = "\"/catalog\" request error rate in the last 360 mins measured at API Gateway with a 6% burn rate",
        signalQuery         = <<-EOT
           AppRequests 
                | where Url !contains "localhost" and Url !contains "/hc"
                | extend httpMethod = tostring(split(Name, ' ')[0])
                | where Name contains "Catalog"
                | summarize
                    succeed = count(Success == true),
                    failed = count(Success == false),
                    total=count()
                    by bin(TimeGenerated, 360m)
                | extend AggregatedValue = todouble(failed) * 10000 / todouble(total)
        EOT
        signalSeverity      = 3,
        frequency           = 15,
        time_window         = 360,
        triggerOperator     = "GreaterThanOrEqualTo",
        triggerThreshold    = 60
    },
     "View Catalog-SuccessRate 10-percent-budget-48hour" = {
        userJourneyCategory = "View Catalog",
        sloCategory         = "ErrorRate",
        sloPercentile       = ""
        sloDescription      = "\"/catalog\" request error rate in the last 360 mins measured at API Gateway with a 1.4% burn rate",
        signalQuery         = <<-EOT
           AppRequests 
                | where Url !contains "localhost" and Url !contains "/hc"
                | extend httpMethod = tostring(split(Name, ' ')[0])
                | where Name contains "Catalog"
                | summarize
                    succeed = count(Success == true),
                    failed = count(Success == false),
                    total=count()
                    by bin(TimeGenerated, 2880m)
                | extend AggregatedValue = todouble(failed) * 10000 / todouble(total)
        EOT
        signalSeverity      = 3,
        frequency           = 60,
        time_window         = 2880,
        triggerOperator     = "GreaterThanOrEqualTo",
        triggerThreshold    = 14
    },
    "Login-SuccessRate" = {
        userJourneyCategory = "Login",
        sloCategory         = "SuccessRate",
        sloPercentile       = ""
        sloDescription      = "99.9% of \"login\" request in the last 60 mins were successful (HTTP Response Code: 200) as measured at API Gateway ",
        signalQuery         = <<-EOT
            AppRequests
                | where Url !contains "localhost" and Url !contains "/hc"
                | extend httpMethod = tostring(split(Name, ' ')[0])
                | where Name contains "login"
                | summarize succeed = count(Success == true), failed = count(Success == false), total=count() by bin(TimeGenerated, 60m)
                | extend AggregatedValue = todouble(succeed) * 10000 / todouble(total)
        EOT
        signalSeverity      = 4,
        frequency           = 60,
        time_window         = 60,
        triggerOperator     = "LessThan",
        triggerThreshold    = 9990
    }
}
