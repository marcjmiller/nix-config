{ ... }:
{
  programs.zsh = {
    sessionVariables = {
      EDITOR = "vim";
      BROWSER = "firefox";
    };

    shellAliases = {
      pp = "pulumi";
      creds = "source ~/.config/2fctl/credentials.sh";
      shell = "nix develop -c $SHELL";
      homecfg = "zed ~/nix-config";
      rl = "source ~/.zshrc";
      extip = "curl icanhazip.com/v4";
      kcu = "2fctl kubeconfig update";
      gcat = "git commit --all --template ~/.gitmessage";
      gwup = "pushd ~/workspace/govcloud && 2fctl git clone && popd";
      watch = "watch ";
    };
  };
}
