#!/usr/bin/env bash

if [[ -d ${HOME}/opt/bin ]]; then
  export PATH="${HOME}/opt/bin:${PATH}"
fi

# Use for history
mkdir "${HOME}/.psql"
