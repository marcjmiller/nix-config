{ ... }:
{
  programs.zsh = {
    sessionVariables = {
      EDITOR = "vim";
      BROWSER = "firefox";
    };

    shellAliases = {
      gpc = "find . -mindepth 1 -maxdepth 1 -type d | xargs -P5 -I{} git -C {} pull";
      pp = "pulumi";
      creds = "source ~/.config/2fctl/credentials.sh";
      shell = "nix develop -c $SHELL";
      homecfg = "zed ~/nix-config";
      rl = "source ~/.zshrc";
      extip = "curl icanhazip.com/v4";
      kcu = "2fctl kubeconfig update";
      gcat = "git commit --all --template ~/.gitmessage";
      gwup = "pushd ~/workspace/govcloud && find . -type d -name .git -exec dirname {} \\; | xargs -P10 -n1 -I{} bash -c 'output=\$(git -C {} pull --quiet 2>&1); status=\$?; if [ \$status -eq 0 ]; then echo \"🔄 Pulling {} ... ✅\"; else echo \"🔄 Pulling {} ... ❌\"; echo \"[\$(date)] {}: \$output\" >> ~/gwup-failures.txt; fi' && popd";
      watch = "watch ";
    };
  };
}
