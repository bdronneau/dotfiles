# dotfiles-skeleton

A `.dotfiles` repository skeleton

## Installation

```
git clone --depth 1 https://github.com/ViBiOh/dotfiles-skeleton.git
./dotfiles-skeleton/install.sh
```

## SSH

```bash
ssh-keygen -t ed25519 -a 100 -C "`whoami`@`hostname`" -f ~/.ssh/id_ed25519
```

## Bash

Then change default bash for root

```bash
sudo -s
echo $(brew --prefix)/bin/bash >> /etc/shells
chsh -s $(brew --prefix)/bin/bash
```

And also for current user

```bash
chsh -s $(brew --prefix)/bin/bash
```

Under OS X you need to create `.bash_profile` with
```bash
if [[ -f "${HOME}/.bashrc" ]]; then
  source ${HOME}/.bashrc
fi
```
