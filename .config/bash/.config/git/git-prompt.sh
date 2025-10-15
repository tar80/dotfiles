PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]' # set window title
PS1="$PS1"'\n'                 # new line
# PS1="$PS1"'\[\033[32m\]'       # change to green
# PS1="$PS1"'\u@\h '             # user@host<space>
PS1="$PS1"'\[\033[35m\]'       # change to purple
PS1="$PS1"'$MSYSTEM '          # show MSYSTEM
PS1="$PS1"'\[\033[33m\]'       # change to brownish yellow
PS1="$PS1"'\w'                 # current working directory
PS1="$PS1"'\[\033[0m\]'        # change color
PS1="$PS1"'\n'                 # new line
PS1="$PS1"'$ '                 # prompt: always $

MSYS2_PS1="$PS1"               # for detection by MSYS2 SDK's bash.basrc

## Evaluate all user-specific Bash completion scripts (if any)
# for c in "$HOME"/.config/bash/completion/*.bash
# do
#   # Handle absence of any scripts (or the folder) gracefully
#   test ! -f "$c" ||
#     . "$c"
#   done
