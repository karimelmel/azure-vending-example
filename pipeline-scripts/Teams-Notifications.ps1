param(
  # Microsoft Teams Chat Id that will receive the notification in the format: "Microsoft Teams Chat Id that will receive the notification in the format https://.webhook.office.com/webhookb2/00000000-0000-0000-0000-000000000000@00000000-0000-0000-0000-000000000000/IncomingWebhook/00000000000000000000000000000000/00000000-0000-0000-0000-000000000000"
  [Parameter(HelpMessage="Microsoft Teams Chat Id that will receive the notification in the format: 'https://.webhook.office.com/webhookb2/00000000-0000-0000-0000-000000000000@00000000-0000-0000-0000-000000000000/IncomingWebhook/00000000000000000000000000000000/00000000-0000-0000-0000-000000000000'")]
  [String]$TeamsWebHookURL,

  [Parameter()]
  [String]$WebhookMessageText,

  [Parameter()]
  [String]$WebhookMessageTitle
)

$ErrorActionPreference = "Stop"

$webhookMessage = [PSCustomObject][Ordered]@{
  "@type"      = "FF0000"
  "@context"   = "http://schema.org/extensions"
  "themeColor" = '700015'
  "title"      = $WebhookMessageTitle
  "text" = $WebhookMessageText
}

$webhookJSON = ConvertTo-Json $webhookMessage -Depth 50

$webhookCall = @{
  "URI"         = $TeamsWebHookURL
  "Method"      = 'POST'
  "Body"        = $webhookJSON
  "ContentType" = 'application/json'
}
try {
    Invoke-RestMethod @webhookCall
}
catch {
    Write-Error "Error posting message in  $TeamsWebHookURL `n Error: $($_.Exception.Message)"
}
