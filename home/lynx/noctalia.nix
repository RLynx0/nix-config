{ config, ... }:
let
  wallpaperDirectory = "${config.home.homeDirectory}/Personal/Pictures/wallpapers";
  wallpaper = "${wallpaperDirectory}/UT-Umbrella-Shortened.jpg";
  scripts = "${config.xdg.configHome}/hypr/scripts";
  loginBox = output: cx: cy: {
    type = "login_box";
    inherit output cx cy;
    box_height = 213.0;
    box_width = 810.0;
    rotation = 0.0;
    settings = {
      background_color = "surface_container";
      background_opacity = 0.88;
      background_radius = 12.0;
      center_password_text = false;
      input_opacity = 1.0;
      input_radius = 6.0;
      layout = "regular";
      show_caps_lock = true;
      show_keyboard_layout = true;
      show_login_button = true;
      show_session_buttons = true;
    };
  };
in
{
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = {
      bar.default = {
        background_opacity = 0.75;
        center = [ "workspaces" ];
        end = [
          "wallpaper"
          "clipboard"
          "notifications"
          "bluetooth"
          "network"
          "volume"
          "brightness"
          "battery"
          "clock"
          "session"
        ];
        start = [
          "control-center"
          "launcher"
          "media"
          "tray"
        ];
        margin_ends = 50;
        thickness = 32;
        widget_spacing = 8;
      };
      dock.smart_auto_hide = true;
      theme = {
        mode = "dark";
        source = "wallpaper";
        wallpaper_scheme = "soft";
        templates = {
          enable_builtin_templates = false;
          enable_community_templates = false;
        };
      };
      wallpaper = {
        directory = wallpaperDirectory;
        default.path = wallpaper;
      };
      widget.media.hide_when_no_media = true;
      audio.enable_overdrive = true;
      nightlight.enabled = false;
      storage.key_source = "secret-service";
      notification.enable_daemon = true;
      shell = {
        polkit_agent = true;
        clipboard_enabled = true;
        clipboard_history_max_entries = 100;
        clipboard_keep_from_closed_apps = true;
        clipboard_auto_paste = "auto";
        launcher.auto_paste = "auto";
        screenshot = {
          copy_to_clipboard = true;
          save_to_file = true;
          freeze_screen = true;
          directory = "${config.home.homeDirectory}/Personal/Pictures/screenshots";
        };
        session.actions = [
          { action = "lock"; }
          {
            action = "hibernate";
            label = "Hibernate";
            command = "systemctl hibernate";
          }
          { action = "logout"; }
          { action = "shutdown"; }
          { action = "suspend"; }
          { action = "reboot"; }
        ];
      };
      lockscreen = {
        enabled = true;
        fingerprint = true;
        allow_empty_password = false;
      };
      lockscreen_widgets = {
        enabled = false;
        schema_version = 2;
        widget_order = [
          "lockscreen-login-box@eDP-1"
          "lockscreen-login-box@HDMI-A-1"
        ];
        widget = {
          "lockscreen-login-box@eDP-1" = loginBox "eDP-1" 564.0 561.5;
          "lockscreen-login-box@HDMI-A-1" = loginBox "HDMI-A-1" 960.0 889.5;
        };
      };
      idle = {
        behavior_order = [
          "dim-locked"
          "screen-off-locked"
          "dim"
          "lock"
          "screen-off"
          "lock-and-suspend"
        ];
        behavior = {
          dim-locked = {
            enabled = true;
            action = "command";
            timeout = 20.0;
            command = "${scripts}/idle-dim.sh locked";
            resume_command = "${scripts}/idle-dim.sh restore";
          };
          screen-off-locked = {
            enabled = true;
            action = "command";
            timeout = 30.0;
            command = "noctalia msg status | jq -e '.locked' >/dev/null && noctalia msg dpms-off";
            resume_command = "noctalia msg dpms-on";
          };
          dim = {
            enabled = true;
            action = "command";
            timeout = 150.0;
            command = "${scripts}/idle-dim.sh unlocked";
            resume_command = "${scripts}/idle-dim.sh restore";
          };
          lock = {
            enabled = true;
            action = "lock";
            timeout = 160.0;
          };
          screen-off = {
            enabled = true;
            action = "screen_off";
            timeout = 180.0;
          };
          lock-and-suspend = {
            enabled = true;
            action = "lock_and_suspend";
            timeout = 1800.0;
          };
        };
      };
      hooks.session_unlocked = [ "${scripts}/panic/lock.sh restore" ];
    };
  };
}
