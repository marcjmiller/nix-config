{ 
  buildFHSEnv, 
  lib,
  openssh,
  pkgs, 
  stdenv,
  ... 
}:
let
  agentBinary = /opt/hexnode/hexnode_agent;
  hexnode = stdenv.mkDerivation {
    pname = "hexnode-agent";
    version = "1.0.0";
  
    src = agentBinary;
  
    nativeBuildInputs = [ openssh ];
  
    unpackPhase = "true";
  
    installPhase = ''
      cp $src $out
    '';
    
    meta = with lib; {
      description = "Hexnode agent for NixOS";
      license = licenses.mit;
      maintainers = [ marcjmiller ];
    };
  };
in
buildFHSEnv {
  name = "ha-bash";
  targetPkgs = pkgs: [ openssh ];

  extraInstallCommands = ''
    ln -s ${hexnode}/hexnode_agent $out/bin/
  '';

  runScript = "bash";
}
