# set common variables
export ROOT=/System/Volumes/Data
export HOME=$ROOT/Users/asdingfs

# Python
export PATH="/usr/local/opt/python/bin:$PATH"
# some pip packages are installed in these paths
export PATH="/System/Volumes/Data/Users/asdingfs/.local/bin"
# google cloud platform, as there are multiple interpreters in the system
export CLOUDSDK_PYTHON="/System/Volumes/Data/Users/asdingfs/.pyenv/versions/3.11.6/bin/python"

# PostgreSQL
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
# For pkg-config to find postgresql@15 you may need to set:
#   export PKG_CONFIG_PATH="/opt/homebrew/opt/postgresql@15/lib/pkgconfig"

# To restart postgresql@15 after an upgrade:
#   brew services restart postgresql@15
# Or, if you don't want/need a background service you can just run:
#   LC_ALL="C" /opt/homebrew/opt/postgresql@15/bin/postgres -D /opt/homebrew/var/postgresql@15

# RVM & Rubies
export LDFLAGS="-L/usr/local/opt/ruby/lib"
export CPPFLAGS="-I/usr/local/opt/ruby/include"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="$HOME/.rvm/bin:$PATH" # Add RVM to PATH for scripting

# First priority PATHs
export PATH="/usr/bin/:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/mysql/bin:$PATH"
export MANPATH="/usr/local/man:$MANPATH"
export PATH="/usr/local/bin:$PATH"

# Last priority PATHs
export PATH=$PATH:/bin

# Brew
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
