{ pkgs-unstable, ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    package = pkgs-unstable.helix;

    extraPackages = with pkgs-unstable; [
      clang-tools
      emmet-language-server
      lldb
      lua-language-server
      nil
      nixd
      nixfmt
      perlnavigator
      rust-analyzer
      taplo
      tinymist
      tombi
      vscode-langservers-extracted
    ];

    settings = {
      theme = "dark-lynx";

      editor = {
        bufferline = "multiple";
        line-number = "relative";
        scrolloff = 8;
        rulers = [ ];
        file-picker.hidden = false;
        color-modes = true;

        auto-completion = true;
        completion-trigger-len = 1;
        idle-timeout = 0;
        auto-format = true;

        indent-guides = {
          render = true;
          character = "▏";
        };

        statusline = {
          left = [
            "mode"
            "spinner"
            "file-name"
          ];
          center = [
            # "file-base-name"
            # "separator"
            # "selections"
            # "position-percentage"
            # "total-line-numbers"
          ];
          right = [
            "diagnostics"
            "file-encoding"
            "file-type"
            "separator"
            "position"
          ];

          separator = "│";
          mode.normal = "NOR";
          mode.insert = "INS";
          mode.select = "SEL";
        };
      };

      keys.normal = {
        esc = [
          "collapse_selection"
          "keep_primary_selection"
        ];

        Y = "yank_joined";

        ret = {
          w = ":w";
          W = ":w!";
          q = ":q";
          Q = ":q!";
          x = ":bc";
          X = ":bc!";
          f = ":format";
          r = ":reload-all";

          c = ":config-reload";
          C = ":config-open";
          A-c = ":o .helix/config.toml";
          s = ":o ~/.config/helix/themes/dark-lynx.toml";
          l = ":lsp-restart";
          L = ":o ~/.config/helix/languages.toml";
          A-l = ":o .helix/languages.toml";
        };

        "+" = {
          b = ":sh cargo build";
          B = ":sh cargo build --release";
          r = ":sh cargo run";
          t = ":sh cargo test";
          T = ":sh cargo test -- --nocapture";
          d = ":sh cargo doc --open";
          f = ":sh leptosfmt .";
        };

        "#" = {
          s = ":set whitespace.render all";
          S = ":set whitespace.render none";
          r = ":set rulers [80]";
          R = ":set rulers []";
          f = ":toggle auto-format";
          g = ":toggle indent-guides.render";
          h = ":toggle lsp.display-inlay-hints";
          c = ":toggle color-modes";
          w = ":toggle soft-wrap.enable";
        };
      };

      keys.insert = {
        C-h = "move_char_left";
        C-l = "move_char_right";
        C-w = "move_next_word_start";
        C-e = "move_next_word_end";
        C-b = "move_prev_word_start";
      };
    };

    languages = {
      language-server.rust-analyzer.config = {
        cargo.allFeatures = true;
        procMacro.ignored.leptos_macro = [ "server" ];
      };

      language-server.emmet-lsp = {
        command = "emmet-language-server";
        args = [ "--stdio" ];
      };

      language = [

        {
          name = "rust";
          debugger = {
            command = "lldb-vscode";
            name = "lldb-vscode";
            port-arg = "--port {}";
            transport = "tcp";

            templates = [
              {
                name = "binary";
                request = "launch";
                args = {
                  program = "{0}";
                  runInTerminal = true;
                };
                completion = [
                  {
                    completion = "filename";
                    name = "binary";
                  }
                ];
              }
            ];
          };
        }

        {
          name = "css";
          auto-format = false;
        }

        {
          name = "html";
          auto-format = false;
          language-servers = [
            "vscode-html-language-server"
            "emmet-lsp"
          ];
        }

        {
          name = "nix";
          auto-format = false;
          formatter.command = "nixfmt";
        }

      ];
    };

    themes.dark-lynx =
      let
        dark-0 = "#121416";
        dark-1 = "#33353a";
        dark-2 = "#44484e";
        light-0 = "#808488";
        light-1 = "#c8cacc";
        light-2 = "#fbfdff";

        dark-b0 = "#283034";
        dark-b1 = "#30383c";
        dark-b2 = "#40545a";
        light-b0 = "#609498";
        light-b1 = "#a8dadc";
        light-b2 = "#d0ffff";

        red = "#d05850";
        orange = "#d08050";
        yellow = "#d0b080";
        green = "#60d0a0";
        aqua = "#60c0c0";
        blue = "#50a0d0";
        magenta = "#c080d8";

        orange_dark = "#a02000";
        green_dark = "#306040";
        blue_dark = "#004060";

        line.style = "line";
        crossed-out = [ "crossed-out" ];
        italic = [ "italic" ];
        bold = [ "bold" ];
        bold-italic = [
          "bold"
          "italic"
        ];

        fg = fg: { inherit fg; };
        bg = bg: { inherit bg; };
        fgAndBg = fg: bg: { inherit fg bg; };
        mods = modifiers: { inherit modifiers; };
        fgAndMods = fg: modifiers: { inherit fg modifiers; };
        bgAndMods = bg: modifiers: { inherit bg modifiers; };
        fgBgAndMods = fg: bg: modifiers: { inherit fg bg modifiers; };
        fgUnderlined = fg: underline: { inherit fg underline; };
        bgUnderlined = bg: underline: { inherit bg underline; };
        diagnostic = color: {
          underline = {
            style = "curly";
            inherit color;
          };
        };
      in
      {
        # editor
        "ui.text" = fg light-1;
        "ui.text.focus" = fgAndMods orange bold;
        "ui.text.inactive" = fg light-0;
        "ui.linenr" = fg light-0;
        "ui.linenr.selected" = fg light-1;
        "ui.selection" = bg dark-2;
        "ui.cursor" = fgAndBg dark-0 light-0;
        "ui.cursor.select" = fgAndBg dark-0 light-b0;
        "ui.cursor.match" = bgUnderlined dark-2 line;
        "ui.cursor.primary" = fgAndBg dark-0 light-1;
        "ui.cursor.primary.select" = fgAndBg dark-0 light-b1;
        "ui.cursorline.primary" = bg dark-b1;
        "ui.cursorline.secondary" = bg dark-b0;

        # menus
        "ui.background" = bg dark-0;
        "ui.background.separator" = fg light-0;
        "ui.menu" = fgAndBg light-1 dark-1;
        "ui.menu.selected" = bgAndMods orange bold;
        "ui.window" = fgAndBg dark-2 dark-0;
        "ui.popup" = bg dark-1;
        "ui.help" = bg dark-0;
        "ui.statusline" = fgAndBg light-2 dark-2;
        "ui.statusline.inactive" = fgAndBg light-0 dark-b1;
        "ui.statusline.normal" = fgBgAndMods green_dark green bold;
        "ui.statusline.insert" = fgBgAndMods orange_dark orange bold;
        "ui.statusline.select" = fgBgAndMods blue_dark blue bold;
        "ui.bufferline" = fgAndBg light-1 dark-2;
        "ui.bufferline.active" = bgAndMods dark-0 bold;

        # virtual
        "ui.virtual.ruler" = bg dark-1;
        "ui.virtual.whitespace" = fg dark-b2;
        "ui.virtual.indent-guide" = fg dark-b2;
        "ui.virtual.inlay-hint" = fg light-0;
        "ui.virtual.wrap" = fg light-0;

        # diff
        "diff.plus" = green;
        "diff.delta" = blue;
        "diff.minus" = red;

        # feedback;
        "hint" = green;
        "info" = blue;
        "warning" = yellow;
        "error" = red;

        "diagnostic.hint" = diagnostic green;
        "diagnostic.info" = diagnostic blue;
        "diagnostic.warning" = diagnostic yellow;
        "diagnostic.error" = diagnostic red;

        # lsp;
        "comment" = fgAndMods light-0 italic;
        "type" = fg green;
        "constant" = fgAndMods light-b2 italic;
        "constant.builtin" = fgAndMods aqua italic;
        "constant.builtin.boolean" = fgAndMods magenta italic;
        "constant.numeric" = fg magenta;
        "constant.character.escape" = green;
        "string" = fgAndMods aqua italic;
        "string.regexp" = fg green;
        "string.special" = fg yellow;
        "variable" = fg light-1;
        "variable.builtin" = fgAndMods blue italic;
        "variable.parameter" = fg light-1;
        "variable.other.member" = fg blue;
        "label" = fg orange;
        "punctuation" = fg light-0;
        "punctuation.delimiter" = fg light-0;
        "punctuation.bracket" = fg light-1;
        "punctuation.special" = fg blue;
        "keyword" = fg red;
        "keyword.operator" = fg magenta;
        "keyword.directive" = fg magenta;
        "keyword.storage" = fg red;
        "operator" = fg orange;
        "function" = fg yellow;
        "function.macro" = fgAndMods blue italic;
        "namespace" = fgAndMods green italic;
        "tag" = fg orange;
        "attribute" = fgAndMods magenta italic;
        "constructor" = fg blue;
        "module" = fg green;
        "special" = fgUnderlined red line;

        # markup;
        "markup.heading.marker" = fg light-0;
        "markup.heading.1" = fgAndMods red bold-italic;
        "markup.heading.2" = fgAndMods orange bold-italic;
        "markup.heading.3" = fgAndMods yellow bold-italic;
        "markup.heading.4" = fgAndMods green bold-italic;
        "markup.heading.5" = fgAndMods blue bold-italic;
        "markup.heading.6" = fgAndMods magenta bold-italic;
        "markup.list" = fg red;
        "markup.bold" = mods bold;
        "markup.italic" = mods italic;
        "markup.strikethrough" = mods crossed-out;
        "markup.link.url" = fgUnderlined blue line;
        "markup.link.label" = fg orange;
        "markup.link.text" = fg magenta;
        "markup.quote" = fgAndMods light-0 italic;
        "markup.raw.inline" = fg green;
        "markup.raw.block" = fgAndBg aqua dark-0;
      };
  };
}
