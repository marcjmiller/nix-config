{
  autoPatchelfHook,
  bluez,
  cacert,
  coreutils, # 1. Added coreutils to the argument list
  curl,
  dbus,
  dmidecode,
  fakeroot,
  openssh,
  glib,
  glibc,
  gobject-introspection,
  lib,
  makeWrapper,
  networkmanager,
  patchelf,
  proot,
  shadow,
  stdenv, # stdenv provides coreutils and bash
  systemd,
  util-linux,
  ...
}:

let
  # hexnodeInstaller = fetchurl {
  #   url = "https://secondfront.hexnodemdm.com/enroll/";
  #   sha256 = "1q4dhhi9m6yfjiriarv0glrprz3miswx6rj6ncyczgnv88ppndvw";
  # };

  # hexnodeAgent = fetchurl {
  #   url = "https://.../path/to/hexnode_agent";
  #   sha256 = "0000000000000000000000000000000000000000000000000000";
  # };

  # Hardcode the host-specific values
  systemUUID = "4c4c4544-004e-5710-804c-b5c04f465933";
  systemSerial = "5NWLFY3";
in

stdenv.mkDerivation {
  pname = "hexnode";
  version = "1.0.1";

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    coreutils # Need coreutils for setup
    curl
    fakeroot
    patchelf
    proot
  ];

  buildInputs = [
    bluez
    cacert
    dbus
    glib
    glibc
    gobject-introspection
    dmidecode
    networkmanager
    openssh
    shadow
    systemd
    util-linux
  ];

  dontUnpack = true;

  buildPhase = ''
      runHook preBuild

      echo "Creating fake FHS root in ./fakeroot"
      mkdir -p fakeroot/usr/local/bin
      mkdir -p fakeroot/usr/bin
      mkdir -p fakeroot/bin
      mkdir -p fakeroot/etc/hexnode_agent
      mkdir -p fakeroot/etc/ssl/certs
      mkdir -p fakeroot/etc/systemd/system
      mkdir -p fakeroot/stubs

      echo "Linking essential tools into fakeroot..."
      # Link coreutils
      for tool in ${coreutils}/bin/*; do
        ln -s $tool fakeroot/bin/$(basename $tool)
      done

      # Link env specifically to /usr/bin
      ln -s ${coreutils}/bin/env fakeroot/usr/bin/env

      # Link bash
      ln -s ${stdenv.shell} fakeroot/bin/bash
      ln -s ${stdenv.shell} fakeroot/bin/sh

      # Link curl
      ln -s ${curl}/bin/curl fakeroot/bin/curl

      # Link systemctl
      ln -s ${systemd}/bin/systemctl fakeroot/bin/systemctl

      # Link SSL certificates for HTTPS
      ln -s ${cacert}/etc/ssl/certs/ca-bundle.crt fakeroot/etc/ssl/certs/ca-bundle.crt
      ln -s ${cacert}/etc/ssl/certs/ca-bundle.crt fakeroot/etc/ssl/certs/ca-certificates.crt

      echo "Creating dmidecode stub..."
      cat > fakeroot/stubs/dmidecode <<EOF
    #!/usr/bin/env bash
    if [ "\$1" = "-s" ] && [ "\$2" = "system-uuid" ]; then
      echo "${systemUUID}"
      exit 0
    fi
    if [ "\$1" = "-s" ] && [ "\$2" = "system-serial-number" ]; then
      echo "${systemSerial}"
      exit 0
    fi
    exec ${dmidecode}/bin/dmidecode "\$@"
    EOF
      chmod +x fakeroot/stubs/dmidecode

      echo "Creating rm stub..."
      cat > fakeroot/stubs/rm <<'EOF'
    #!/usr/bin/env bash
    if [[ "$@" =~ /etc/hexnode_agent ]] || [[ "$@" =~ /usr/local/bin/hexnode_agent ]]; then
        exit 0
    fi
    exec ${coreutils}/bin/rm "$@"
    EOF
      chmod +x fakeroot/stubs/rm

      echo "Downloading installer..."
      curl -L https://secondfront.hexnodemdm.com/enroll/ -o fakeroot/hexnode_installer
      chmod +x fakeroot/hexnode_installer
      autoPatchelf fakeroot/hexnode_installer

      echo "--- Running installer with proot ---"
      ${fakeroot}/bin/fakeroot ${proot}/bin/proot \
        -r fakeroot \
        -b /nix:/nix \
        -b /etc/resolv.conf:/etc/resolv.conf \
        -b /etc/hosts:/etc/hosts \
        -b /etc/nsswitch.conf:/etc/nsswitch.conf \
        -w / \
        /usr/bin/env \
          PATH="/stubs:/bin:/usr/bin:${coreutils}/bin:${curl}/bin:${systemd}/bin:${openssh}/bin" \
          SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt \
          /hexnode_installer
      echo "--- Installer finished ---"

      runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    echo "--- installPhase: Copying files from FHS root ---"

    # Create the target directories in $out
    mkdir -p $out/usr/local/bin
    mkdir -p $out/etc/hexnode_agent
    mkdir -p $out/lib/systemd/system

    # --- Copy the agent binary ---
    if [ -f "fakeroot/usr/local/bin/hexnode_agent" ]; then
      echo "Copying hexnode_agent binary..."
      cp fakeroot/usr/local/bin/hexnode_agent $out/usr/local/bin/.hexnode_agent-unwrapped
      chmod +x $out/usr/local/bin/.hexnode_agent-unwrapped

      # Set rpath to include all our library paths
      patchelf --set-rpath "${lib.makeLibraryPath [ 
        dbus 
        glib 
        glibc 
        gobject-introspection 
        systemd 
      ]}" $out/usr/local/bin/.hexnode_agent-unwrapped || true

      autoPatchelf $out/usr/local/bin/.hexnode_agent-unwrapped

      echo "After patching:"
      ldd $out/usr/local/bin/.hexnode_agent-unwrapped || true

      makeWrapper $out/usr/local/bin/.hexnode_agent-unwrapped $out/usr/local/bin/hexnode_agent \
        --set SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt" \
        --prefix PATH : "${
          lib.makeBinPath [
            bluez
            coreutils
            curl.bin
            dbus
            networkmanager
            openssh
            shadow
            systemd
            util-linux.bin
          ]
        }" \
        --prefix LD_LIBRARY_PATH : "${
          lib.makeLibraryPath [
            bluez
            dbus
            glib
            glibc
            gobject-introspection
            systemd
          ]
        }"
    else
      echo "INSTALL ERROR: hexnode_agent not found in fakeroot/usr/local/bin/"
      exit 1
    fi

    # --- Copy the config directory ---
    if [ -d "fakeroot/etc/hexnode_agent" ]; then
      echo "Copying hexnode_agent config..."
      cp -R fakeroot/etc/hexnode_agent/. $out/etc/hexnode_agent
    else
      echo "INSTALL ERROR: /etc/hexnode_agent not found in fakeroot/etc/"
      exit 1
    fi

    # --- Copy the systemd service file ---
    if [ -f "fakeroot/etc/systemd/system/hexnode_agent.service" ]; then
      echo "Copying systemd service file..."
      cp fakeroot/etc/systemd/system/hexnode_agent.service $out/lib/systemd/system/
    else
      echo "INSTALL ERROR: hexnode_agent.service not found in fakeroot/etc/systemd/system/"
      exit 1
    fi

    runHook postInstall
  '';

  meta = with lib; {
    description = "Hexnode agent for NixOS";
    # license = licenses.unfree;
    maintainers = [ "marcjmiller" ];
  };
}
