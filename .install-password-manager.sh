#!/bin/sh

# exit immediately if password-manager-binary is already in $PATH
type pass >/dev/null 2>&1 && exit

case "$(uname -s)" in
Linux)
  sudo apt install pass
  ;;
*)
  echo "unsupported OS"
  exit 1
  ;;
esac
