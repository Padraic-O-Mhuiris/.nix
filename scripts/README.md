
# Locally install system

Need two usb sticks:

- One for nixos live usb to be installed
- Another for connect_wifi.sh

### Boot to live usb

Should be straightforward enough, depending on your machine you can find the bootloader in the BIOS somewhere and select the usb with the nixos image which has been prepared on it. If successful it should boot to a term under `[nixos@nixos] $`.

### Use root

Dropping in to root environment makes it easier install things

``` shell
sudo -i
```

### Connect to wifi

In order to install the os proper, we must connect to the internet to get all the packages necessary. There is a script, `connect_wifi.sh` which should take care of this for you. It also prepares an ssh environment which makes it easy for users to manage the install from a more comfortable environment. 

First though, we need to mount the usb stick in order to manage it. This can be done using `udisksctl`.

``` shell
$ usdisksctl mount -b /dev/sdx1
```

The device path may be different and the output if successful will indicate a mountpoint using the users name and the device label. In my case it is `/run/media/nixos/BACKUP`.

Running the script should be straightforward:

``` shell
/path/to/usb/mount/dir/connect_wifi.sh
```

The output will ask for the wifi SSID and Password so it can find and connect to it. This will create a wifi.text file making it easy to connect again if necessary. Then it should ask for a password for the user so it is possible to ssh.

### Bootstrapping

We need access to the install.sh script in this project so jump into a nix-shell with git for better access

``` shell
nix-shell -p git
```

Clone the repo

``` shell
git clone https://github.com/Padraic-O-Mhuiris/.nix.git
```

Edit the installation script so it specifies the correct directories. It should already be an executable so run:

``` shell
~/.nix/scripts/install.sh
```

Sometimes it may fail unexpectedly due to what was on the disks prior but a second run will sort that out. Verify that the hardware-configuration.nix is auto-generated with the swap and host id added. Also verify that the configuration.nix is the one specified in the minimal-nix-flake-configuration

Install:

``` shell
nixos-install --no-root-passwd
```

Should run through the process without issue and reboot, removing the installation media

### Post install

- Connect wifi through network-manager
- Pull nix project into home dir via https

``` shell
git clone https://github.com/Padraic-O-Mhuiris/.nix.git
```

- Copy /etc/nixos/hardware-configuration.nix to correct host directory

``` shell
cp /etc/nixos/hardware-configuration.nix ~/.nix/hosts/<HOST>
```

- Delete all files /etc/nixos

``` shell
rm -rf /etc/nixos/*
```

- Rebuild the system into the correct configuration through the flake. Reboot the system afterwards. Dapptools can be a bit hormonal as cachix does not detect the dapphub registry. Maybe this can be alleviated by ensuring cachix is installed in the minimal config but disabling during this first run saves having to rebuild the project.

``` shell
sudo nixos-rebuild --flake "$HOME/.nix#<HOST>" switch
```

- Pull public key into keyring

``` shell
gpg --import ~/.nix/keys/<GPG_ID>.gpg
```

- Change `.nix` project from https to ssh

``` shell
cd ~/.nix && git remote set-url origin git@github.com:Padraic-O-Mhuiris/.nix.git
```

- Insert the yubikey into an available usb port and validate that it is detected. Not running this command will cause the card not to be detected when committing changes

``` shell
gpg --card-edit
```

- Verify and validate gpg, git and ssh is working by committing the changes to the .nix project made when the hardware-configuration was imported.

``` shell
git commit -am "updated hardware-configuration"

git push origin main
```

- cleanup files, system should be functionally configured
- pull in other projects, secrets and org files

