# dotfiles

<!-- markdownlint-disable MD013 MD002 -->

[![](https://github.com/bdronneau/dotfiles/workflows/shellcheck/badge.svg)](https://github.com/bdronneau/dotfiles/actions?query=branch%3Amaster)

[![Vulnerabilities](https://sonarcloud.io/api/project_badges/measure?project=bdronneau_dotfiles&metric=vulnerabilities)](https://sonarcloud.io/dashboard?id=bdronneau_dotfiles) [![Code Smells](https://sonarcloud.io/api/project_badges/measure?project=bdronneau_dotfiles&metric=code_smells)](https://sonarcloud.io/dashboard?id=bdronneau_dotfiles) [![Security Rating](https://sonarcloud.io/api/project_badges/measure?project=bdronneau_dotfiles&metric=security_rating)](https://sonarcloud.io/dashboard?id=bdronneau_dotfiles) [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=bdronneau_dotfiles&metric=alert_status)](https://sonarcloud.io/dashboard?id=bdronneau_dotfiles)

Yet another `.dotfiles` repository

## Installation

_debug_: `DOTFILES_DEBUG=true`

```bash
git clone --depth 1 git@github.com:bdronneau/dotfiles.git
bash ./dotfiles/install.sh
```

## Configuration

On start if `DOTFILES_CONFIG` is not defined, script will ask to load one of configuration file available in `config/`.

Script search for `DOTFILES_filenamefrominstalldir` environment variable. For example, if `export DOTFILES_NODE=true` so install/node.sh will be take care in consideration.

This is reverse from <https://github.com/ViBiOh/dotfiles#configuration>

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

## Manual actions

### Global

```bash
pyenv install 3.10.0
```

### Manjaro

```bash
sudo pacman -S vim gcc
```

in `.localrc`

```bash
export WORKON_HOME=~/.virtualenvs
source /usr/bin/virtualenvwrapper.sh
```

## Testing

Using [shellcheck](https://www.shellcheck.net/).

### Run

```bash
shellcheck -P bin/ -x bin/utils.sh init.sh
shellcheck -P bin/ -x bin/utils.sh install/*.sh
```

## Links

- Based on work done by [@ViBiOh](https://github.com/ViBiOh/dotfiles)
- <https://github.com/alrra/dotfiles>
- <https://github.com/cowboy/dotfiles>
- <https://github.com/mathiasbynens/dotfiles>
