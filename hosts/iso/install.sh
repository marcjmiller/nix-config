
# This is temporary, first boot we will register a FIDO2 token as the drive decryption method.
# Disko currently doesn't support configuring crypted for a FIDO2 or TPM2 decryption this is
# this is left up to the end user.
echo "Setting up Drive Encryption"
echo -n "__DRIVE_PASSWORD__" > /tmp/secret.key

cp -R /iso/cfg /tmp/cfg
echo "Generating NixOS Hardware Configuration"
nixos-generate-config --dir "/tmp/cfg/hosts/__HOSTNAME__" --no-filesystems

echo "Partitioning Drive and Installing NixOS"
disko-install --flake "/tmp/cfg#__HOSTNAME__" --disk main /dev/nvme0n1 --write-efi-boot-entries

echo "Copying Configuration to Installed System"
mount /dev/mapper/crypted /mnt
mkdir -p /mnt/home/__USER__/nix-config
cp -R /tmp/cfg/* /mnt/home/__USER__/nix-config
nixos-enter -c 'chown -R __USER__:users /home/__USER__/nix-config'
nixos-enter -c 'chmod -R +w /home/__USER__/nix-config'

echo "Setting user __USER__ password"
nixos-enter -c 'passwd __USER__'
