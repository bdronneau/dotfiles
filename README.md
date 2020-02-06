# dotfiles

Yet another `.dotfiles` repository

## Installation

```
git clone --depth 1 git@github.com:bdronneau/dotfiles.git
bash ./dotfiles/install.sh
```

## Configuration

See https://github.com/ViBiOh/dotfiles#configuration for custom installation


## Bash

### Compatibility

Since a using an os with old bash version, backward is implement

```bash
local OS=$(uname -s | tr '[:upper:]' '[:lower:]')
```

instead of

```bash
local ARCH=$(uname -m)
echo "${ARCH,,}"
```

### Mac

### Default shells
Changing the default shell (done by `install/_packages.sh`)

```bash
sudo -s
echo $(brew --prefix)/bin/bash >> /etc/shells
chsh -s $(brew --prefix)/bin/bash
```

And also for current user

```bash
chsh -s $(brew --prefix)/bin/bash
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

## Testing

Using [shellcheck](https://www.shellcheck.net/).

## Links

  - Based on work done by [@ViBiOh](https://github.com/ViBiOh/dotfiles)
