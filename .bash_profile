alias ls='ls -GFh'

# Make a base58 password that is 64 chars long (probably too long):
alias random_password='cat /dev/random | LC_CTYPE=C tr -cd 123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz | head -c${1:-64}; echo'

# https://coderwall.com/p/euwpig/a-better-git-log
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# include .bashrc if it exists
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
