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
      EDITOR = "vim";
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
        "thefuck"
        "z"
      ];
    };

    shellAliases = {
      creds = "source ~/.config/2fctl/credentials.sh";
      extip = "curl icanhazip.com/v4";
      gcat = "git commit --all --template ~/.gitmessage";
      gpc = "find . -mindepth 1 -maxdepth 1 -type d | xargs -P5 -I{} git -C {} pull";
      gwup = "pushd ~/workspace/govcloud && find . -type d -name .git -exec dirname {} \\; | xargs -P10 -n1 -I{} bash -c 'output=\$(git -C {} pull --quiet 2>&1); status=\$?; if [ \$status -eq 0 ]; then echo \"🔄 Pulling {} ... ✅\"; else echo \"🔄 Pulling {} ... ❌\"; echo \"[\$(date)] {}: \$output\" >> ~/gwup-failures.txt; fi' && popd";
      homecfg = "zed ~/nix-config";
      kcu = "2fctl kubeconfig update";
      pp = "pulumi";
      rl = "source ~/.zshrc";
      shell = "nix develop -c $SHELL";
      watch = "watch ";
    };

    initContent = ''
      2f() {
        AWS_USE_FIPS_ENDPOINT=false 2fctl login -a $1 -r $2 && source ~/.config/2fctl/credentials.sh
      }
    '';
  };
}
