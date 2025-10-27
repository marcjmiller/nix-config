{
  buildFHSEnv,
  pkgs,
  ...
}:

let
  hexnode-config = pkgs.writeScript "hexnode-config-wrapper" ''
    #!${pkgs.bash}/bin/sh
    exec /home/files/hexnode/config "$@"
  '';
in
buildFHSEnv {
  name = "hexnode-fhsenv";
  targetPkgs = pkgs: [ ]; # Add any dependencies hexnode might have here

  extraInstallCommands = ''
    ln -s ${hexnode-config} $out/bin/hexnode-config
  '';

  runScript = "hexnode-config";
}
