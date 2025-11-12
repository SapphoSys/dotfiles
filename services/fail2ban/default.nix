{ config, pkgs, ... }:

{
  age.secrets.abuseipdb = {
    file = ../../secrets/abuseipdb.age;
    mode = "600";
  };

  services.fail2ban = {
    enable = true;

    # Include curl for making HTTP requests to AbuseIPDB
    extraPackages = [ pkgs.curl ];

    # Globally applicable settings for all jails
    daemonSettings = {
      Definition = {
        # How long to keep an IP in the ban list (in seconds)
        # 1 day = 86400 seconds
        bantime = "86400";

        # How far back to look for failures (in seconds)
        # 1 hour = 3600 seconds
        findtime = "3600";

        # Number of failures before banning
        maxretry = 3;

        # Allow fail2ban to write to syslog
        logtarget = "SYSLOG";
      };
    };

    # Ignore local networks and trusted services
    ignoreIP = [
      "127.0.0.1/8"
      "::1"
      "100.64.0.0/10" # Tailscale IP range
    ];

    # Jails for protecting various services
    jails = {
      # SSH protection - monitor failed login attempts
      sshd.settings = {
        enabled = true;
        port = "ssh";
        filter = "sshd";
        logpath = "%(syslog_authpriv)s";
        backend = "auto";
        maxretry = 5;
        findtime = "3600";
        bantime = "86400";
        action = "iptables-multiport[name=SSH, port='ssh']\nabuseipdb[abuseipdb_apikey=${config.age.secrets.abuseipdb.path}, abuseipdb_category='18,22', abuseipdb_comment='Fail2Ban SSH Brute Force']";
      };

      # Caddy HTTP/HTTPS protection - monitor for repeated 4xx/5xx errors
      caddy-http.settings = {
        enabled = true;
        port = "http,https";
        filter = "caddy-http";
        logpath = "/var/log/caddy/access.log";
        backend = "auto";
        maxretry = 10;
        findtime = "600";
        bantime = "3600";
        action = "iptables-multiport[name=Caddy, port='http,https']\nabuseipdb[abuseipdb_apikey=${config.age.secrets.abuseipdb.path}, abuseipdb_category='21', abuseipdb_comment='Fail2Ban Caddy Abuse']";
      };

      # Rate-based protection - ban on excessive requests
      caddy-ratelimit.settings = {
        enabled = true;
        port = "http,https";
        filter = "caddy-ratelimit";
        logpath = "/var/log/caddy/access.log";
        backend = "auto";
        maxretry = 50;
        findtime = "60";
        bantime = "1800";
        action = "iptables-multiport[name=Caddy-RateLimit, port='http,https']\nabuseipdb[abuseipdb_apikey=${config.age.secrets.abuseipdb.path}, abuseipdb_category='21', abuseipdb_comment='Fail2Ban Rate Limiting']";
      };
    };
  };

  # Custom filters for Fail2Ban
  environment.etc = {
    # Caddy HTTP error monitoring filter
    "fail2ban/filter.d/caddy-http.conf".text = ''
      [Definition]
      failregex = ^<HOST> -.*" (?:400|401|403|404|405|429|500|502|503|504) .*$
      ignoreregex =
    '';

    # Caddy rate limiting filter - detects repeated requests within short timeframe
    "fail2ban/filter.d/caddy-ratelimit.conf".text = ''
      [Definition]
      failregex = ^<HOST> -.*" \d{3} .*$
      ignoreregex =
    '';

    # AbuseIPDB action for reporting IPs
    # The API key is passed via the abuseipdb_apikey parameter which should be
    # set to the path of the decrypted secret file (e.g., /run/agenix/abuseipdb)
    "fail2ban/action.d/abuseipdb.conf".text = ''
      [Definition]
      actionstart =
      actionstop =
      actioncheck =

      # Report IP to AbuseIPDB
      # Reads the API key from the file specified in the abuseipdb_apikey parameter
      actionban = /run/current-system/sw/bin/curl -s -X POST https://api.abuseipdb.com/api/v2/report \
        -H "Key: $(cat <abuseipdb_apikey>)" \
        -H "Accept: application/json" \
        -d "ip=<ip>&category=<abuseipdb_category>&comment=<abuseipdb_comment>" \
        -o /dev/null

      # No action to unban - AbuseIPDB reports are permanent
      actionunban =

      [Init]
      # Default path - will be overridden by jail configuration
      abuseipdb_apikey = /run/agenix/abuseipdb
      abuseipdb_category = 18
      abuseipdb_comment = Fail2Ban Report
    '';
  };
}
