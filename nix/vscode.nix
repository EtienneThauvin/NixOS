{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        ms-python.python
        ms-vscode.cpptools
        ms-azuretools.vscode-docker
        esbenp.prettier-vscode
        jnoortheen.nix-ide
      ];

      userSettings = {
        "editor.formatOnSave" = true;
        "editor.fontSize" = 15;
        "editor.tabSize" = 3;
        "editor.rulers" = [ ];
        "workbench.colorTheme" = "Dark 2026";
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "nix.serverSettings.nil.formatting.command" = [ "nixpkgs-fmt" ];
        "claudeCode.claudePath" = "/run/current-system/sw/bin/claude";
        "git.path" = "/run/current-system/sw/bin/git";
        "terminal.integrated.defaultLocation" = "editor";
      };
    };
  };
  home.packages = with pkgs; [
    nil
    statix
    nixpkgs-fmt
  ];
}
