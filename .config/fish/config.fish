#Aliases
alias count_d 'echo */ | wc'

set OS (uname)
if test "$OS" = "Darwin"
    alias ls 'exa'

    # Initialise pyenv
    source (pyenv init --path | psub)
end

# Add to PATH
export PATH="$PATH:$HOME/.local/bin"

# Initialise starship
starship init fish | source

# Solve issue with wrongly set TERM variable because of Kitty
set TERM 'xterm-256color'
