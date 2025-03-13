# Dotfiles

This repository contains my personal dotfiles and configuration files for various tools and applications.

## Prerequisites

Before you begin, ensure you have [Homebrew](https://brew.sh/) installed on your macOS system. If you don't have it installed yet, run:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Installation

### 1. Clone this repository

```bash
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
```

### 3. Install packages from Brewfile

The Brewfile includes browsers, development tools, utilities, and applications. To install everything in the Brewfile:

```bash
brew bundle
```

This will install all the formulae, casks, and fonts specified in the Brewfile.

### 4. Install dotfiles 

To use the dotfiles in this repository, use [GNU Stow](https://www.gnu.org/software/stow/):

```bash
brew install stow
```

#### Using GNU Stow for zsh configuration

GNU Stow creates symlinks from your dotfiles repository to your home directory. For zsh configuration files:

1. Make sure your dotfiles are organized in a directory structure that mirrors your home directory:
   ```
   dotfiles/
   └── zsh/
       └── .zshrc
   ```

2. From your dotfiles directory, run:
   ```bash
   stow --target=$HOME zsh
   stow --target=$HOME alias
   stow --target=$HOME gitconfig
   stow --target=$HOME gitignore
   stow --target=$HOME stow-global-ignore
   ...
   ```

   This will create a symlink `~/.zshrc` that points to `dotfiles/zsh/.zshrc`.

3. Verify the symlinks were created:
   ```bash
   ls -la ~/.zshrc
   ```

With this setup, any changes you make to the .zshrc file in your dotfiles repository will be reflected in your home directory, allowing you to easily track your zsh configuration in your dotfiles repo.

## Updating

To update all packages installed by Homebrew:

```bash
brew update && brew upgrade
```

To update this repository with your latest configurations:

```bash
# Update Brewfile with currently installed packages
brew bundle dump --force
```
