{ config, ... }:

{
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
      "./data/cursor.txt:/app/cursor.txt"
      "./data/labels.db:/app/labels.db"
      "./data/labels.db-shm:/app/labels.db-shm"
      "./data/labels.db-wal:/app/labels.db-wal"
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
