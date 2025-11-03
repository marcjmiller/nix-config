{
  stdenv,
  lib,
  autoPatchelfHook,
  buildFHSEnv,
  dbus,
  openssh,
  glib,
  glibc,
  gobject-introspection,
  zlib,
  ...
}:
let
  hexnode = stdenv.mkDerivation {
    pname = "hexnode-agent";
    version = "1.0.0";

    src = /opt/hexnode/hexnode_agent;

    nativeBuildInputs = [ autoPatchelfHook ];

    buildInputs = [
      openssh
      dbus
      glib
      glibc
      gobject-introspection
      zlib
    ];

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      mkdir -p $out/etc/hexnode_agent

      cp $src $out/bin/hexnode_agent

      chmod +x $out/bin/hexnode_agent
      runHook postInstall
    '';

    meta = with lib; {
      description = "Hexnode agent for NixOS";
      license = licenses.unfree;
      maintainers = with maintainers; [ marcjmiller ];
    };
  };
in
buildFHSEnv {
  name = "ha-bash";

  targetPkgs = _pkgs: [
    glib
    glibc
    hexnode
    openssh
  ];

  runScript = "bash";
}
