#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'


# https://launchpad.net/~fish-shell/+archive/ubuntu/release-3
install_fish()
{
    sudo apt-add-repository ppa:fish-shell/release-3
    sudo apt update
    sudo apt install fish
}

set_fish_default_shell()
{
    chsh -s $(which fish)
}

# https://github.com/jorgebucaran/fisher
install_fisher()
{
    curl -sL https://git.io/fisher -o fisher_tmp
    fish -c ". fisher_tmp && fisher install jorgebucaran/fisher"
    rm -rf fisher_tmp
}

# https://github.com/jorgebucaran/hydro#configuration
install_prompt()
{
    fish -c "fisher install jorgebucaran/hydro"
    # fish -c "set --universal hydro_symbol_prompt 'λ'"
    fish -c "set --universal hydro_multiline true"
}


install_fish
set_fish_default_shell
install_fisher
install_prompt
