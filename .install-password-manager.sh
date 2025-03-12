#!/bin/sh

# exit immediately if password-manager-binary is already in $PATH
type pass >/dev/null 2>&1 && exit

# install password manager
case "$(uname -s)" in
Linux)
  sudo apt install pass
  ;;
*)
  echo "unsupported OS"
  exit 1
  ;;
esac

# init password store repository
git clone git@github.com:ThomasCode92/password-store.git .password-store
pass init $PASS_GPG_KEY