{ config, ... }:

{

  systemd.tmpfiles.rules = [
    "d /var/lib/destiny-labeler/data 0755 root root -"
    "f /var/lib/destiny-labeler/data/cursor.txt 0644 root root -"
    "f /var/lib/destiny-labeler/data/labels.db 0644 root root -"
    "f /var/lib/destiny-labeler/data/labels.db-shm 0644 root root -"
    "f /var/lib/destiny-labeler/data/labels.db-wal 0644 root root -"
  ];
  age.secrets.destiny-labeler = {
    file = ../../secrets/destiny-labeler.age;
    mode = "600";
  };

  virtualisation.oci-containers.containers."destiny-labeler" = {
    image = "ghcr.io/sapphosys/destiny-labeler:main";
    pull = "always";
    autoRemoveOnStop = false;
    ports = [ "4001:4001" ];
    environment = {
      DID = "did:plc:zt2oycjggn5gwdtcgphdh4tn";
      SIGN_KEY = config.age.secrets.destiny-labeler.path;
      URL = "wss://jetstream.atproto.tools/subscribe";
      NODE_ENV = "production";
    };
    volumes = [
      "/var/lib/destiny-labeler/data/cursor.txt:/app/cursor.txt"
      "/var/lib/destiny-labeler/data/labels.db:/app/labels.db"
      "/var/lib/destiny-labeler/data/labels.db-shm:/app/labels.db-shm"
      "/var/lib/destiny-labeler/data/labels.db-wal:/app/labels.db-wal"
    ];
    extraOptions = [
      "--restart=always"
      "--network=host"
    ];
  };

  services.caddy.virtualHosts."labeler.sappho.systems" = {
    extraConfig = ''
      import common
      import tls_cloudflare
      reverse_proxy http://destiny-labeler:4001
    '';
  };
}
