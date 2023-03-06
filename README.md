# How to self host a website
Self-hosted website using Google Domains, Caddy Server, and Cloudflare in a
Windows environment.

# Steps
## Router configuration
1. Assign / reserve a static IP for your host machine.
2. Forward port 443 to this IP.

## Purchase a domain from Google Domains
Choose any you'd like. As of 2023, some .com and .org domains can be purchased
for as low as $12 per year.

## Cloudflare setup
1. Create a new website. Name it whatever (or just the domain name).
2. DNS -> records -> add new A record.
   ```
   Name: <your domain name>              # example: myselfhost.dev
   IPv4 address: <your public IP>
   Proxy status: Proxied
   TTL: Auto
   ```
3. (Optional) Add a new CNAME record.
   ```
   Name: <subdomain>                     # example: media
   Target: @
   Proxy status: Proxid
   TTL: Auto
   ````
4. SSL -> Overview -> Change TLS encryption mode to Full (strict).
6. Top right -> My Profile -> API Tokens -> Create Token ->
   Create Custom Token
   ```
   Token name: Caddy API token
   Permissions: 
   - Zone.Zone.Read
   - Zone.DNS.Edit
   Zone Resources:
   Include.Specific Zone.<your domain name>
   ```
   This is your `<api_token>`
6. Go to Cloudflare Nameserver section and take note of these two names.
   For example, it should look like `something.ns.cloudflare.com`

## Custom nameserver in Google Domains
1. Click your domain -> DNS -> Custom Name servers tab
2. Make sure to click "Switch to Custom Name servers" link
3. Add the two name servers from the above

## Caddy Server as your reverse proxy
1. Go to https://caddyserver.com/ and click Download
2. Click `caddy-dns/cloudflare` module (it'll highlight blue and the "Extra
   features" number will change to 1.
3. Download and rename to `caddy.exe`.
4. Copy this file into some directory for example: `C:\website`
5. Copy from this repo `./config/Caddyfile` into the above directory.
6. Update this file with:
   - Your `<api_token>`.
   - Your `<target>`. This is the target web server on your machine.
   - Your `<host_name>`. This is the domain/subdomain you are listening on.

## NSSM tool to make Caddy run as a Windows service
1. Go to https://nssm.cc/download and download the binary
2. Extract and run `nssm.exe install`.
3. A new window will open. Fill it out with these details:
   ```
   Application tab
   ---
   Program: C:\website\caddy.exe
   Start in: C:\website\
   Arguments: run --config Caddyfile
   Service name: Caddy

   Details tab
   ---
   Display Name: Caddy Server
   Startup type: Automatic
   ```
4. Click save. This will install the service.
5. `nssm.exe run Caddy` will start the service.

## Powershell to update your dynamic IP in CLoudflare
1. If you haven't already, download and install Powershell 7.1+.
2. Copy `.\scripts\*.ps1` files to `C:\website\scripts`.
3. Update `schedule_task.ps1`:
   - `<script_path>` this is the absolute path to the powershell scripts.
   - `<email>` this is the email you used for Cloudflare.
   - `<api_token>` this is the same token as before.
   - `<dns_domain>` this is the domain name you registered.
   - `<dns_record>` this is the record to update.
4. Run `schedule_task.ps1`. This schedules a task every 30 minutes to run
   `refresh_ip.ps1`, which will update Cloudflare of any changes in your
   public IP.
s
# Troubleshooting
## I'm getting ERR_TOO_MANY_REDIRECTS in the browser
Make sure to change your SSL settings in CLoudflare to Full (strict).