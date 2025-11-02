{ config, pkgs, ... }:

{
  age.secrets = {
    minioCredentials = {
      file = ../../secrets/minio.age;
      mode = "600";
      owner = "minio";
      group = "minio";
    };

    outlineClientSecret = {
      file = ../../secrets/outline/client-secret.age;
      mode = "600";
      owner = "outline";
      group = "outline";
    };
    outlineMinioSecret = {
      file = ../../secrets/outline/minio-password.age;
      mode = "600";
      owner = "outline";
      group = "outline";
    };
    outlineSecretKey = {
      file = ../../secrets/outline/secret-key.age;
      mode = "600";
      owner = "outline";
      group = "outline";
    };
    outlineSMTPPassword = {
      file = ../../secrets/outline/smtp-password.age;
      mode = "600";
      owner = "outline";
      group = "outline";
    };
    outlineUtilsSecret = {
      file = ../../secrets/outline/utils-secret.age;
      mode = "600";
      owner = "outline";
      group = "outline";
    };
  };

  services.outline = {
    enable = true;
    publicUrl = "https://wiki.sappho.systems";
    port = 3300;
    forceHttps = true;

    secretKeyFile = config.age.secrets.outlineSecretKey.path;
    utilsSecretFile = config.age.secrets.outlineUtilsSecret.path;

    databaseUrl = "postgres://outline:${builtins.readFile config.age.secrets.outlineSecretKey.path}@localhost/outline?sslmode=disable";
    redisUrl = "redis://127.0.0.1:6380";

    storage = {
      storageType = "s3";
      accessKey = "minio";
      secretKeyFile = config.age.secrets.outlineMinioSecret.path;
      uploadBucketUrl = "https://minio.sappho.systems";
      uploadBucketName = "outline";
      region = "us-east-1";
      uploadMaxSize = 104857600;
      importMaxSize = 104857600;
      workspaceImportMaxSize = 104857600;
      forcePathStyle = true;
      acl = "private";
    };

    smtp = {
      host = "smtp.purelymail.com";
      port = 587;
      username = "noreply@sapphic.moe";
      passwordFile = config.age.secrets.outlineSMTPPassword.path;
      fromEmail = "noreply@sapphic.moe";
      secure = false;
    };

    oidcAuthentication = {
      displayName = "Pocket ID";

      clientId = "257b92c1-6b7f-41e9-a9c6-858a083295d8";
      clientSecretFile = config.age.secrets.outlineClientSecret.path;

      authUrl = "https://id.sappho.systems/authorize";
      tokenUrl = "https://id.sappho.systems/api/oidc/token";
      userinfoUrl = "https://id.sappho.systems/api/oidc/userinfo";
      logoutUrl = "https://id.sappho.systems/api/oidc/end-session";

      usernameClaim = "preferred_username";
      scopes = [
        "openid"
        "profile"
        "email"
        "groups"
      ];

      disableRedirect = true;
    };
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    dataDir = "/var/lib/postgresql";
    enableTCPIP = true;
    ensureDatabases = [ "outline" ];
    ensureUsers = [
      {
        name = "outline";
        password = builtins.readFile config.age.secrets.outlineSecretKey.path;
      }
    ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database DBuser origin-address auth-method
      local all      all     trust
      host  all      all     127.0.0.1/32   scram-sha-256
      host  all      all     ::1/128        scram-sha-256
    '';
  };

  # Ensure Outline waits for Postgres
  systemd.services.outline.requires = [ "postgresql.service" ];
  services.redis.servers."outline" = {
    enable = true;
    port = 6380;
    bind = "127.0.0.1";
  };

  services.minio = {
    enable = true;
    rootCredentialsFile = config.age.secrets.minioCredentials.path;
    dataDir = "/var/lib/minio";
    listenAddress = [
      "0.0.0.0:9000"
      "0.0.0.0:9001"
    ];
  };

  services.caddy.virtualHosts."wiki.sappho.systems" = {
    extraConfig = ''
      import common
      import tls_cloudflare
      reverse_proxy http://localhost:3300
    '';
  };

  settings.firewall.allowedTCPPorts = [ 3300 ];
}
