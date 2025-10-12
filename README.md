# motd

![MOTD-Screenshot](screenshot.png)

Custom MOTD scripts based on [Skrepysh's motd](https://github.com/Skrepysh/motd),
which is based on [Spookdev-MOTD](https://github.com/NeonWizard/spookdev-motd),
which is based on [PlexMOTD](https://github.com/40Cakes/PlexMOTD).

## Features

- runs on Ubuntu or Debian
- the scripts are split into manageable chunks
- automatic hostname detection
- easy to install and maintain

## Installation

Run the install script:

```bash
curl -L https://raw.githubusercontent.com/Steeven9/motd/refs/heads/master/scripts/install.sh > motd_install.sh

sudo chmod +x motd_install.sh && sudo ./motd_install.sh
```

## Customization

Change `/etc/update-motd.d/colors.txt` to your liking.

Change services in `/etc/update-motd.d/09-services` to suit your needs.

Set `PRINT_CONTAINERS` to 1 in `/etc/update-motd.d/10-docker` if you want
to see the full list of running Docker containers

Add more scripts!
