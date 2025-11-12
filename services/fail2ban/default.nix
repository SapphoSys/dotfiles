{ config, pkgs, ... }:

{
  age.secrets.abuseipdb = {
    file = ../../secrets/abuseipdb.age;
    mode = "600";
  };

  services.fail2ban = {
    enable = true;

    # Include curl and jq for making HTTP requests to AbuseIPDB
    extraPackages = [ pkgs.curl pkgs.jq ];

    # Global default settings for all jails
    bantime = "1d";
    findtime = "1h";
    maxretry = 3;

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
        filter = "sshd";
        backend = "systemd";
        maxretry = 5;
        findtime = "1h";
        bantime = "1d";
        action = "iptables-multiport[name=SSH, port='ssh']\nabuseipdb-notify[abuseipdb_apikey=${config.age.secrets.abuseipdb.path}]";
      };

      # Caddy HTTP/HTTPS protection - monitor for repeated 4xx/5xx errors
      caddy-http.settings = {
        enabled = true;
        filter = "caddy-http";
        logpath = "/var/log/caddy/access.log";
        backend = "auto";
        maxretry = 10;
        findtime = "10m";
        bantime = "1h";
        action = "iptables-multiport[name=Caddy, port='http,https']\nabuseipdb-notify[abuseipdb_apikey=${config.age.secrets.abuseipdb.path}]";
      };

      # Rate-based protection - ban on excessive requests
      caddy-ratelimit.settings = {
        enabled = true;
        filter = "caddy-ratelimit";
        logpath = "/var/log/caddy/access.log";
        backend = "auto";
        maxretry = 50;
        findtime = "1m";
        bantime = "30m";
        action = "iptables-multiport[name=Caddy-RateLimit, port='http,https']\nabuseipdb-notify[abuseipdb_apikey=${config.age.secrets.abuseipdb.path}]";
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

    # AbuseIPDB action for reporting IPs to the abuse database
    "fail2ban/action.d/abuseipdb-notify.conf".text = ''
      [Definition]
      actionstart =
      actionstop =
      actioncheck =

      # Report IP to AbuseIPDB API
      actionban = /run/current-system/sw/bin/curl -s -X POST https://api.abuseipdb.com/api/v2/report \
        -H "Key: $(cat <abuseipdb_apikey>)" \
        -H "Accept: application/json" \
        -d "ip=<ip>&category=15&comment=Fail2Ban%20-%20<name>" \
        -o /dev/null

      # No actionunban - AbuseIPDB reports are permanent
      actionunban =

      [Init]
      abuseipdb_apikey = /run/agenix/abuseipdb
    '';
  };
}
