{
  pkgs,
  ...
}:

{
  # Minecraft server settings
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers.fabric = {
      enable = true;

      # Fabric server package - specify version and loader version
      package = pkgs.fabricServers.fabric-1_21_1.override {
        loaderVersion = "0.18.1";
      };

      # Link mods into the server
      symlinks = {
        mods = pkgs.linkFarmFromDrvs "mods" (
          builtins.attrValues {
            # Fabric API - essential for most mods
            Fabric-API = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/dQ3p80zK/fabric-api-0.138.3%2B1.21.10.jar";
              sha512 = "0wcqcq4w8b4cm1qk7m55bqm9wcp7006sf1x9822li4i078biqd8v1rbk4p9b7kj1cykx1xhnfagdhsswg295dhcyz8pd5197ijs6wyw";
            };

            Cloth-Config-API = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/9s6osm5g/versions/qMxkrrmq/cloth-config-20.0.149-fabric.jar";
              sha512 = "1idlykc44nlbakfjd991fs0kn2c9fhgn2mgc97fspq9k1c4alr1mrax530fppa8q5zyh1a9dfi4axqdgfv6ayzib44gqr6w941rw7fz";
            };

            # Lithium - server optimization mod
            Lithium = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/NsswKiwi/lithium-fabric-0.20.1%2Bmc1.21.10.jar";
              sha512 = "2xh4f84hj080qwcmvi7b8p80spj6dlznmxvl2zra0qb264lsiv2lv2hym60q66hgjx3m7x173zmbj95rkydhzcj94kb2frz28nqkckr";
            };

            # No-Chat-Reports = pkgs.fetchurl {
            #   url = "https://cdn.modrinth.com/data/qQyHxfxd/versions/78RjC1gi/NoChatReports-FABRIC-1.21.10-v2.16.0.jar";
            #   sha512 = "1rwgjvhcd9asnlsg5vvw5c3h590wch6db0sjfrm81p35hrbwgxr2rlsnfkbrr1lmd1yrd67gxa6i5nmhl0cg74b5c0r10izyy2g5cir";
            # };

            # Simple-Voice-Chat = pkgs.fetchurl {
            #   url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/BjR2lc4k/voicechat-fabric-1.21.10-2.6.6.jar";
            #   sha512 = "2bi3rkb254jlvbmki2giaxv36kpv7i46xgndd3lxa9jmg3vghz8s3bgi7jkgna4xqfywhw48l32ysi2sicv9cwxpzmazp86165862zw";
            # };

            # NetherPortalFix = pkgs.fetchurl {
            #   url = "https://cdn.modrinth.com/data/nPZr02ET/versions/EQ03E7hB/netherportalfix-fabric-1.21.10-21.10.1.jar";
            #   sha512 = "2c9dm0p3yba9a9nr5qnrlajifp544hcjm9rkxmfp191zbza6qs22gqw58r73q194qf1r42lsaqs1dfdk5hljjks934g54yfqilqb3bf";
            # };

            # LetMeDespawn = pkgs.fetchurl {
            #   url = "https://cdn.modrinth.com/data/vE2FN5qn/versions/bsbIiM1c/Letmedespawn-1.21.9-fabric-1.5.2b.jar";
            #   sha512 = "008zkgannx5462f63ihd6rnjwzdmhv9y10nmc4230cy01m8cqlrq17625k6mjg6iv8lip75in1yrw58z0mipd8fmdndpxcgpghwl4kg";
            # };

            # Veinminer = pkgs.fetchurl {
            #   url = "https://cdn.modrinth.com/data/OhduvhIc/versions/lCVEKyxE/veinminer-fabric-2.5.0.jar";
            #   sha512 = "0liivch5f11kdmw62mn4mx1x18jbwsixzmb8i01i8xdc9q3jaay607rpnlsyp1xs1fc2hlb5wm3sby8443gdx9fw1pwv27q3fp3n6r1";
            # };
          }
        );
      };

      whitelist = {
        SapphicAngels = "945d7491-ba43-422b-83a0-e637d788b6ba";
      };

      operators = {
        SapphicAngels = {
          uuid = "945d7491-ba43-422b-83a0-e637d788b6ba";
          level = 4;
          bypassesPlayerLimit = true;
        };
      };

      # jvmOpts = "-Xms4G -Xmx6G -XX:+UseG1GC -XX:MaxGCPauseMillis=200";

      serverProperties = {
        motd = "Sapphic Angels' Fabric Minecraft Server";
        max-players = "20";
        difficulty = "normal";
        pvp = true;
        white-list = true;
      };
    };
  };
}
