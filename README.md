## Installation

- Follow luks encyrpted installation instructions outlined [here](https://gist.github.com/walkermalling/23cf138432aee9d36cf59ff5b63a2a58)
- Change encrypted volume UUID to one which corresponds in boot.nix `cryptsetup luksUUID /dev/nvme0n1p2 --uuid "11111111-1111-1111-1111-111111111111"`
- Execute `sudo nixos-generate-config --root /mnt` as outlined in the instructions
- Store the resulting `hardware-configuration.nix` somewhere
- Import gpg keys from usb and generate ssh key for github interaction
- Clone this repo to the liveusb's home directory
- Copy the generated `hardware-configuration.nix` in `/mnt/etc/nixos` over the one used in the project
- Push changes if any
- Unlock git-crypted files
- Execute `sudo nixos-install -I <PATH_TO_CONFIGURATION.NIX> --no-root-passwd`
- If installation successful, `mv <PATH_TO_.NIX> /mnt/home/padraic`
- `rm -rf /mnt/etc/nixos && ln -s /mnt/home/padraic/.nix/Hydrogen /mnt/etc/nixos` - symlink /etc/nixos to /home/padraic/.nix/Hydrogen
- Reboot, it's required to `chown` the .nix repo to the user, probably can be done before rebooting but can be done after also 
