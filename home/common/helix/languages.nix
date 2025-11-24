{
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
}
