# dotfiles

Yet another `.dotfiles` repository

## Installation

```
git clone --depth 1 git@github.com:bdronneau/dotfiles.git
bash ./dotfiles/install.sh
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

## ARCH

### Manual actions

```bash
$ sudo pacman -S vim python-virtualenvwrapper gcc
```

in `.localrc`
```bash
export WORKON_HOME=~/.virtualenvs
source /usr/bin/virtualenvwrapper.sh
```

## Links

  - Based on work done by [@ViBiOh](https://github.com/ViBiOh/dotfiles)
