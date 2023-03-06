# Code taken from: https://adamtheautomator.com/cloudflare-dynamic-dns/

# Define the scheduled task action properties
## Enter the PowerShell script path
$scriptPath = '<script_path>'
## Cloudflare account's email address
$Email = '<email>'
## Cloudflare API Token
$Token = '<api_token>'
## DNS Domain Name
$Domain = '<dns_domain>'
## DNS Record to Update
$Record = '<dns_record>'

# Create the scheduled task action object
$taskAction = New-ScheduledTaskAction `
    -Execute "pwsh.exe" `
    -Argument "-File $scriptPath -Email $Email -Token $Token -Domain $Domain -Record $Record"

# Create a bew scheduled task trigger schedule
## Trigger = every 5 minutes for 10 years.
$taskTrigger = New-ScheduledTaskTrigger `
-Once `
-At (Get-Date -Minute 0 -Second 0) `
-RepetitionInterval (New-TimeSpan -Minutes 30) `
-RepetitionDuration (New-TimeSpan -Days 3650)

# Register the scheduled task in the system.
## Scheduled Task Name
$TaskName = 'Update Cloudflare Dynamic DNS'
## Scheduled Task Description
$Description = 'Update Cloudflare DDNS Entry every 30 minutes'
## Create the scheduled task
Register-ScheduledTask `
-TaskName $TaskName `
-Description $Description `
-Action $taskAction `
-Trigger $taskTrigger `
-User 'NT AUTHORITY\SYSTEM'