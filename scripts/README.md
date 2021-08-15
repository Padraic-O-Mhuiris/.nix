
TODO Boot to minimal nix-config that works for that host system that enables flakes


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

### Running os commands over ssh

### 

Jump into unstable nix to use flakes

``` shell
nix-shell -p nixUnstable
```

Install:

``` shell
nixos-install --no-root-passwd
```

# Post install
- pull nix project into home dir
- set git config
- set gpg config
- pull in public gpg 
- delete all files /etc/nixos

``` shell
sudo nixos-rebuild --flake "$HOME/.nix" switch
```


