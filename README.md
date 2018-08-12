# .Zdot
                                    **All the great configuration in my linux.**

These are my own configurations when I'm using linux. If you like it, take it and just give me a star:).

My purpose is beautiful and easz-to-use linux.

Zinux will automatic install the software you need, and soft link the configuration .zshrc into this repo.

Now you can **only** install in system depends **Debian**.

## Software

- vim
- zsh
- stow

## Bash
- .bashrc
- .bash_prompt
- .aliases
- .exports

## Zsh
- .zshrc
- .zsh_alias

  Use **antigen** to manage the bundles of zsh. 

  Now include bundles below:

  - zsh-users/zsh-autosuggestions
  - ael-code/zsh-colored-man-pages
  - zsh-users/zsh-syntax-highlighting
  - mafredri/zsh-async
  - sindresorhus/pure

## Vim
## Git
- .gitconfig

## Install

```shell
git clone --recursive https://github.com/liyzcj/.zdot.git
cd .zdot
# Use zsh
./install.sh zsh
# Use bash
./install.sh bash
```

