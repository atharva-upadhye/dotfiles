{ username, ... }:
{
  system.defaults = {
    dock = {
      autohide = true;
      persistent-apps = [
        "/Applications/Slack.app"
        "/Applications/Google Chrome.app"
        "/Applications/Brave Browser.app"
        "/Applications/Cursor.app"
        "/Applications/Obsidian.app"
        "/Applications/WhatsApp.app"
      ];
    };
    finder.ShowPathbar = true;
    NSGlobalDomain."com.apple.swipescrolldirection" = true;
  };
}
