{
  config,
  lib,
  pkgs,
  ...
}:
let
  wallpaperDirectory = "${config.home.homeDirectory}/Personal/Pictures/wallpapers";
  wallpaper = "${wallpaperDirectory}/UT-Umbrella-Shortened.jpg";
  scripts = "${config.xdg.configHome}/hypr/scripts";
  lockLogo =
    pkgs.runCommand "lynx-lock-logo.png"
      {
        nativeBuildInputs = [ pkgs.imagemagick ];
      }
      ''
        magick ${./assets/lynx-logo.png} -resize '300x300^' -gravity center -extent 300x300 \
          \( -size 300x300 xc:none -fill white -draw 'circle 150,150 150,5' \) \
          -alpha off -compose CopyOpacity -composite \
          -compose Over -fill none -stroke '#444444' -strokewidth 5 \
          -draw 'circle 150,150 150,5' PNG:"$out"
      '';
  lockLayout =
    output: width: height:
    let
      scale = lib.min 1.0 (height / 1080.0);
      widget = type: cy: box_width: box_height: settings: {
        inherit
          type
          output
          cy
          box_width
          box_height
          settings
          ;
        cx = width / 2.0;
        rotation = 0.0;
      };
      text = {
        background = false;
        font_family = config.stylix.fonts.monospace.name;
        shadow = true;
      };
    in
    {
      "lock-date@${output}" = widget "clock" (100.0 * scale) (900.0 * scale) (45.0 * scale) (
        text
        // {
          format = "{:%A, %-d %B %Y}";
          color = "primary";
          center_text = true;
        }
      );
      "lock-time@${output}" = widget "clock" (220.0 * scale) (600.0 * scale) (155.0 * scale) (
        text
        // {
          format = "{:%H:%M}";
          color = "#ffffff";
          center_text = true;
        }
      );
      "lock-logo@${output}" = widget "sticker" (height / 2.0) (300.0 * scale) (300.0 * scale) {
        background = false;
        image_path = "${lockLogo}";
      };
      "lock-user@${output}" = widget "label" (height - 100.0 * scale) (200.0 * scale) (25.0 * scale) (
        text
        // {
          title = config.home.username;
          color = "on_surface";
        }
      );
      "lockscreen-login-box@${output}" = widget "login_box" (height - 150.0 * scale) 400.0 60.0 {
        background_color = "surface_container";
        background_opacity = 0.88;
        background_radius = 12.0;
        center_password_text = true;
        input_opacity = 1.0;
        input_radius = 6.0;
        layout = "compact";
        show_caps_lock = true;
        show_keyboard_layout = true;
        show_login_button = true;
        show_session_buttons = false;
      };
    };
  lockWidgets = lockLayout "eDP-1" 1128.0 752.0 // lockLayout "HDMI-A-1" 1920.0 1080.0;
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
        margin_ends = 6;
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
        greeter_sync.auto_sync = true;
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
        grace_period_seconds = 1;
        transition = [ "fade" ];
        transition_duration = 600.0;
        blur_intensity = 0.3;
        tint_color = "#000000";
        tint_intensity = 0.5;
      };
      lockscreen_widgets = {
        enabled = true;
        schema_version = 2;
        widget_order = builtins.attrNames lockWidgets;
        widget = lockWidgets;
      };
      idle = {
        # The gammashift ramp dims gradually; the default overlay fades fully to black.
        pre_action_fade_seconds = 0.0;
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
            timeout = 0.0;
            locked_timeout = 20.0;
            command = "${scripts}/idle-dim.sh dim";
            resume_command = "${scripts}/idle-dim.sh restore";
          };
          screen-off-locked = {
            enabled = true;
            action = "screen_off";
            timeout = 0.0;
            locked_timeout = 30.0;
          };
          dim = {
            enabled = true;
            action = "command";
            timeout = 150.0;
            command = "${scripts}/idle-dim.sh dim";
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
