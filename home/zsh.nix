{
  pkgs,
  ...
}:
{
  programs.zsh = {
    enable = true;

    plugins = [
      {
        file = "p10k.zsh";
        src = ./files/shell;
        name = "powerlevel10k-config";
      }
      {
        name = "zsh-powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
        file = "powerlevel10k.zsh-theme";
      }
    ];

    autosuggestion.enable = true;
    autocd = true;
    enableCompletion = true;
    history = {
      append = true;
    };
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;

    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "alias-finder"
        "aws"
        "docker"
        "docker-compose"
        "eza"
        "fzf"
        "gitfast"
        "helm"
        "httpie"
        "kubectl"
        "z"
      ];
    };

    shellAliases = {
      creds = "source ~/.config/2fctl/credentials.sh";
      extip = "curl icanhazip.com/v4";
      gcat = "git commit --all --template ~/.gitmessage";
      gpc = "find . -mindepth 1 -maxdepth 1 -type d | xargs -P5 -I{} git -C {} pull";
      gwup = "pushd ~/workspace/govcloud && find . -type d -a ! -name '.git' -exec test -d {}/.git \\; -print | xargs -P10 -I{} bash -c 'repo=\"{}\"; echo \"🔄 Updating \$repo...\"; cd \"\$repo\" && default_branch=\$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed \"s|^refs/remotes/origin/||\" || echo \"main\") && git checkout \"\$default_branch\" --quiet 2>/dev/null && git pull --quiet && echo \"✅ \$repo updated successfully\" || (echo \"❌ \$repo failed to update\" && echo \"[\$(date)] \$repo: \$(git status --porcelain 2>&1 || echo \"git error\")\" >> ~/gwup-failures.txt)' && popd";
      homecfg = "zed ~/nix-config";
      kcu = "2fctl kubeconfig update";
      pp = "pulumi";
      ppss = "pulumi stack select";
      rl = "source ~/.zshrc";
      shell = "nix develop -c $SHELL";
      watch = "watch ";
      manualrbh = "nix run home-manager -- switch --flake ~/nix-config";
      manualrb = "nixos rebuild switch --flake ~/nix-config";
      vi = "nvim";
    };

    initContent = ''
      2f() {
        AWS_USE_FIPS_ENDPOINT=false 2fctl login -a $1 -r $2 && source ~/.config/2fctl/credentials.sh
      }
    '';
  };
}
