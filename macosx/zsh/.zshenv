# set common variables
export ROOT=/System/Volumes/Data
export HOME=$ROOT/Users/asdingfs

# Python
export PATH="/usr/local/opt/python/bin:$PATH"
# some pip packages are installed in these paths
export PATH="/System/Volumes/Data/Users/asdingfs/.local/bin"

# RVM & Rubies
export LDFLAGS="-L/usr/local/opt/ruby/lib"
export CPPFLAGS="-I/usr/local/opt/ruby/include"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="$HOME/.rvm/bin:$PATH" # Add RVM to PATH for scripting

# Brew
export PATH="/opt/homebrew/bin:$PATH"

# First priority PATHs
export PATH="/usr/bin/:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/mysql/bin:$PATH"
export MANPATH="/usr/local/man:$MANPATH"
export PATH="/usr/local/bin:$PATH"
