# nix

NixOS config

## Machines

My machines are named after characters from [Isekai Quartet](https://myanimelist.net/anime/38472/Isekai_Quartet/)

### Albedo

Is my main machine there all the work is done, currently it runs in a VM.

Connected to tailscale

### Rem

Rem is a raspberry pi in my home network also connected to tailscale. It runs all private stuff, like RSS feed manager, bookmark manager, irc bouncer, a WiFi access point and other stuff i don't know yet.  

### Ram

Ram is a raspberry pi and should be there to monitor all other machines (also tailscale).

### Megumin

Megumin is my old laptop. I don't know yet what to do with it but I will probably use it for tasks which need to run overnight or maybe as a steam cache? Seems interesting.

### Aqua

Aqua should be a really hardened server, and a pretty cheap VPS in the cloud (Oracle free tier 1G server?). It only purpose is to have a public facing ssh and connect to my tailscale network.

This should allow my to connect to all machines in my tailscale network without the machine I'm working from to be connected to it. (ssh tunneling is awesome).

### Tanya

Tanya is a public facing (Oracle free tier) server which hosts little websites and APIs

### Emilia

Emilia is ARM server which at least should be a remote builder for arm

### Kazuma

Kazuma is my public facing contabo vps it should not have any connection to tailscale or my home network it should run things like Game Servers which need a little bit of power  

### Beatrice

Beatrice should be just a external SSD which I can boot of. Mainly used so I have a quick *nix-system ready on my Windows laptop to be able to move around the house and connect via rdp to my main workstation and maybe in the future do things like car hacking

## Notes

### sxhkd spawning failed issue

make sure sessionVariable SHELL ist set to something that exists!

### RestrictedPathError

I don't know why but just comment everything that hast to do with home-manager out

### directly install form github flake

```bash
nix-install --root /mnt --flake github:7h3730b/nix#machine
```

### disk space issue

I had multiple problems with this, 'cause I tried to build in a VM with only 2GB /tmp (automatically uses 50% of your RAM) and that is nearly not enough for nerdfonts for example. So there are multiple workarounds:  

If you have a single user system you are in luck just set TMPDIR to any other location and nix should use it.
If you have a multi user system change TMPDIR in your nix daemon config or just do one of these:

- the easiest is to just use NixOps and build remotly on a big machine (best for small vps for example)  
- the hard way is to build a swapFile and than remount a bigger /tmp  

    ```bash
    # create swap file
    sudo dd if=/dev/zero of=/swapfile bs=1024K count=8000
    # change permission
    sudo chmod 600 /swapfile
    # setup Linux swap area
    sudo mkswap /swapfile
    # enable swap
    sudo swapon /swapfile

    # remount /tmp with bigger size
    sudo mount -oremount,size=8G /tmp
    ```

- or if you already know you will have that problem regularly make a big swap in your nix config and set the size of tmp in your nix config
- or just make a symlink to your normal partition  

  ```bash
    sudo rmdir /tmp && ln -s /var/tmp /tmp
  ```

### Proxmox install

Change to uefi boot, add efi drive and add hdd to boot options then follow: https://pve.proxmox.com/wiki/OVMF/UEFI_Boot_Entries to add grub as boot option.

# TODO: 

- set everything up!!!  
- switch to erase your darlings with zfs for some things?  
- draw a graph how everything is connected (home network, tailscale, syncthing) 
- setup syncthing