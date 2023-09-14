# set common variables
export ROOT=/
export HOME=${ROOT}home/$(whoami)

# export user local scripts to path
export PATH="${HOME}/.local/bin:$PATH"
