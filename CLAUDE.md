# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository for macOS. Configuration files are stored in per-tool subdirectories and symlinked to their expected home directory locations via `install.sh`.

## Installation

```bash
# Install all configs
./install.sh

# Install a specific config
./install.sh <config>
```

Valid config names: `bash`, `zsh`, `spacemacs`, `powerline`, `git`, `tmux`, `bin`, `ghci`, `readline`, `cargo`, `guile`, `aws`, `cabal`, `1password`

The script creates symlinks from the repo files into `~/` (or `~/.config/`, `~/.aws/`, etc.). It uses `ln -f -s`, so re-running overwrites existing links.

## Architecture

Each subdirectory maps to a tool and contains its raw config files (no build step):

- **zsh/** — Primary shell. Uses oh-my-zsh with agnoster theme. `zshrc` loads plugins (git, aws, docker, zsh-autosuggestions, zsh-syntax-highlighting, etc.), sets up pyenv, nvm, and ssh-agent. `zshenv` sets PATH and sources cargo. `zprofile` loads nvm and OrbStack.
- **tmux/** — `tmux.conf` uses Nord theme via TPM, has `allow-passthrough` and `extended-keys` enabled for Claude Code compatibility.
- **emacs/** — Spacemacs config with emacs editing style and a custom `galexy` private layer. Heavy org-mode setup with journal, agenda, and LaTeX rendering.
- **git/** — Minimal gitconfig (user info + LFS).
- **1Password/ssh/** — SSH agent config enabling keys from "Lunar" and "Personal" vaults.

## Key Details

- Shell completion for Coursier (`cs`) lives in `zsh/completion/cs`.
- The `bin/ec` script is installed to `~/.local/bin`.
- Tmux history limit is set to 250,000 lines.
