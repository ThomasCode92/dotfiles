#!/bin/bash

# Copy local files and directories to another machine over SSH.

set -euo pipefail

SSH_OPTS=(-o ConnectTimeout=10)
DRY_RUN=0
ASSUME_YES=0
DEST_DIR="."
SOURCES=()

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

usage() {
  cat <<'EOF'
Usage: transfer.sh [options] <user@host> <file-or-directory> [...]

Copy one or more local files or directories over SSH using scp.
Directories are copied recursively, including hidden files. Source names,
permissions, and timestamps are preserved; source files are not removed.

Options:
  -d, --destination <dir>  Existing remote directory (default: home directory).
                           Relative paths are relative to the remote home.
  -y, --yes                Do not ask for confirmation.
  -n, --dry-run            Print the command without connecting or copying.
  -h, --help               Show this help.

Existing files with matching names are overwritten; directories are merged.
scp follows symbolic links, copying their targets rather than the links.
For sensitive files, set restrictive local permissions before transferring.

Examples:
  ./transfer.sh thomas@linux-box.local ~/privatekey.asc ~/publickey.asc
  ./transfer.sh -d Documents thomas@linux-box.local ./notes ./report.pdf
  ./transfer.sh -n thomas@10.0.0.42 "./folder with spaces"
EOF
}

while (($#)); do
  case "$1" in
  -d | --destination)
    [[ $# -ge 2 && -n "$2" ]] || die "Missing value for $1"
    DEST_DIR="$2"
    shift 2
    ;;
  -y | --yes) ASSUME_YES=1 && shift ;;
  -n | --dry-run) DRY_RUN=1 && shift ;;
  -h | --help) usage && exit 0 ;;
  --) shift; break ;;
  -*) die "Unknown option: $1 (see --help)" ;;
  *) break ;;
  esac
done

[[ $# -ge 2 ]] || {
  usage
  die "Specify a destination host and at least one local file or directory"
}
HOST="$1"
shift
[[ "$HOST" =~ ^([a-zA-Z0-9_.-]+@)?([a-zA-Z0-9_.-]+|\[[a-fA-F0-9:]+\])$ && "$HOST" != -* ]] ||
  die "Invalid destination host: $HOST (use an SSH alias, user@host, or user@ip)"

for source in "$@"; do
  [[ -f "$source" || -d "$source" ]] || die "Not a file or directory: $source"
  # Explicit local paths prevent scp from interpreting ':' as a remote source.
  case "$source" in
  /*) SOURCES+=("$source") ;;
  *) SOURCES+=("./$source") ;;
  esac
done

# A trailing slash requires a directory, even when copying a single source.
DESTINATION="$HOST:${DEST_DIR%/}/"
COPY_CMD=(scp -rp "${SSH_OPTS[@]}" -- "${SOURCES[@]}" "$DESTINATION")

if ((DRY_RUN)); then
  echo "Dry run - nothing will be copied"
  printf '%q ' "${COPY_CMD[@]}"
  printf '\n'
  exit 0
fi

command -v scp >/dev/null || die "scp is not installed"
command -v ssh >/dev/null || die "ssh is not installed"

for source in "${SOURCES[@]}"; do
  printf '  %s -> %s\n' "$source" "$DESTINATION"
done
echo "Matching destination files will be overwritten; directories will be merged."

if ((!ASSUME_YES)); then
  read -r -p "Copy to $HOST? [y/N] " reply || reply=""
  [[ "$reply" =~ ^[Yy]$ ]] || {
    echo "Aborted."
    exit 0
  }
fi

"${COPY_CMD[@]}" || die "Transfer failed (check SSH access and the destination directory)"
echo "Done. Files copied to $DESTINATION"
