{
  server = {
    host = "0.0.0.0";
    port = 4040;
  };
  theme = {
    "background-color" = "240 21 15";
    "contrast-multiplier" = 1.2;
    "primary-color" = "316 72 86";
    "positive-color" = "115 54 76";
    "negative-color" = "343 81 75";
  };
  pages = [
    {
      name = "Home";
      columns = [
        {
          size = "small";
          widgets = [
            {
              type = "clock";
              "hour-format" = "24h";
              timezones = [
                {
                  timezone = "Australia/Sydney";
                  label = "Sydney";
                }
                {
                  timezone = "Europe/Istanbul";
                  label = "Istanbul";
                }
                {
                  timezone = "Europe/Amsterdam";
                  label = "Amsterdam";
                }
                {
                  timezone = "Europe/London";
                  label = "London";
                }
                {
                  timezone = "America/Menominee";
                  label = "Wisconsin";
                }
                {
                  timezone = "America/Vancouver";
                  label = "Victoria Island";
                }
              ];
            }
            {
              type = "rss";
              limit = 10;
              "collapse-after" = 3;
              cache = "3h";
              feeds = [
                {
                  url = "https://ovyerus.com/posts/rss.xml";
                  title = "Ovyerus (blog)";
                }
                {
                  url = "https://ovyerus.com/weeknotes/rss.xml";
                  title = "Ovyerus (weeknotes)";
                }
                {
                  url = "https://adryd.com/feed.xml";
                  title = "adryd";
                }
                {
                  url = "https://notnite.com/blog/rss.xml";
                  title = "notnite's blog";
                }
                {
                  url = "https://lyra.horse/blog/posts/index.xml";
                  title = "Lyra (Rebane2001)'s posts";
                }
                {
                  url = "https://maia.crimew.gay/feed.xml";
                  title = "maia blog";
                }
                {
                  url = "https://kibty.town/blog.rss";
                  title = "xyzeva's blog";
                }
                {
                  url = "https://char.lt/blog.rss";
                  title = "charlotte som's blog";
                }
                {
                  url = "https://mae.wtf/rss.xml";
                  title = "vimae's blog";
                }
                {
                  url = "https://cookieplmonster.github.io/feed.xml";
                  title = "Silent's blog";
                }
                {
                  url = "https://kittenlabs.de/index.xml";
                  title = "KittenLabs";
                }
                {
                  url = "https://www.joshwcomeau.com/rss.xml";
                  title = "Josh Comeau's blog";
                }
                {
                  url = "https://astro.build/rss.xml";
                  title = "The Astro Blog";
                }
                {
                  url = "https://tailscale.com/blog/index.xml";
                  title = "Blog on Tailscale";
                }
                {
                  url = "https://www.bungie.net/en/rss/News";
                  title = "Destiny 2";
                }
              ];
            }
            {
              type = "twitch-channels";
              channels = [
                "jerma985"
                "jollywangcore"
                "northernlion"
                "porterrobinson"
                "rtgame"
                "schlatt"
                "vargskelethor"
              ];
            }
          ];
        }
        {
          size = "full";
          widgets = [
            {
              type = "search";
              "search-engine" = "duckduckgo";
              bangs = [
                {
                  title = "YouTube";
                  shortcut = "!yt";
                  url = "https://www.youtube.com/results?search_query={QUERY}";
                }
              ];
            }
            { type = "hacker-news"; }
            {
              type = "videos";
              channels = [
                "UCQEnQfezywrAwkHWX_Uo_Qg"
                "UCQ6fPy9wr7qnMxAbFOGBaLw"
                "UC7Jwj9fkrf1adN4fMmTkpug"
                "UCsBjURrPoezykLs9EqgamOA"
                "UCR-DXc1voovS8nhAvccRZhg"
                "UCRcgy6GzDeccI7dkbbBna3Q"
                "UCS5tt2z_DFvG7-39J3aE-bQ"
                "UCXuqSBlHAE6Xw-yeJA0Tunw"
                "UCWyrVfwRL-2DOkzsqrbjo5Q"
                "UC0fDG3byEcMtbOqPMymDNbw"
                "UCZB6V9fUov0Mx_us3MWWILg"
                "UCKKKYE55BVswHgKihx5YXew"
                "UClY084mbGLK_SLlOfgizjow"
                "UCQD3awTLw9i8Xzh85FKsuJA"
                "UCBa659QWEk1AI4Tg--mrJ2A"
                "UCHC4G4X-OR5WkY-IquRGa3Q"
              ];
            }
            {
              type = "reddit";
              subreddit = "selfhosted";
              "app-auth" = {
                name = "\${REDDIT_APP_NAME}";
                id = "\${REDDIT_APP_CLIENT_ID}";
                secret = "\${REDDIT_APP_SECRET}";
              };
            }
          ];
        }
        {
          size = "small";
          widgets = [
            {
              type = "weather";
              "hour-format" = "24h";
              location = "Almaty, Kazakhstan";
            }
            {
              type = "monitor";
              cache = "1m";
              title = "Services";
              sites = [
                {
                  title = "Outline";
                  url = "https://wiki.sappho.systems";
                  icon = "https://github.com/outline.png";
                }
                {
                  title = "Owncloud";
                  url = "https://cloud.sappho.systems";
                  icon = "si:owncloud";
                }
                {
                  title = "Umami";
                  url = "https://umami.sappho.systems";
                  icon = "https://umami.sappho.systems/apple-touch-icon.png";
                }
              ];
            }
          ];
        }
      ];
    }
  ];
}
