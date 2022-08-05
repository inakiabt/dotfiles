[ ! "$IS_DOTFILES_RUN" == "true" ] && echo "Please run this script from the dotfiles repo root." && exit 1

ARGS_PARSED=0
DEBUG_ENABLED=0
ACCEPT_ENABLED=0
PARAMS=""
while (( "$#" )); do
  case "$1" in
    -d|--debug)
      DEBUG_ENABLED=1
      shift
      ;;
    -y|--yes)
      ACCEPT_ENABLED=1
      shift
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS '$1'"
      shift
      ;;
  esac
done
ARGS_PARSED=1
export DEBUG_ENABLED
export ACCEPT_ENABLED
export ARGS_PARSED
eval set -- "$PARAMS"
if [ $DEBUG_ENABLED -eq 1 ]; then
  echo "Debug mode enabled."
  set -x
fi
