#!/bin/bash

# Convert PowerPoint presentations to PDF with LibreOffice in headless mode.

set -euo pipefail

OUT_DIR=""
INPUTS=()

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

usage() {
  cat <<'EOF'
Usage: pptx2pdf.sh [options] <presentation.pptx> [...]

Convert one or more PowerPoint presentations to PDF using LibreOffice in
headless mode. By default each PDF is written next to its source file.

Options:
  -o, --outdir <dir>  Write all PDFs to <dir> (created if needed).
  -h, --help          Show this help.

On macOS, LibreOffice bundles its own Fontconfig build that looks in
/usr/local/etc/fonts; the Homebrew Fontconfig config is supplied explicitly so
font resolution is consistent and no "no <cachedir> elements found" warnings
appear. On Linux the system Fontconfig is used as-is. Either soffice or
libreoffice is accepted as the LibreOffice command.
A temporary LibreOffice profile is used so an open GUI instance cannot swallow
the headless conversion.

Examples:
  ./pptx2pdf.sh "Documents/My Slides.pptx"
  ./pptx2pdf.sh -o ~/Desktop ./decks/*.pptx
EOF
}

while (($#)); do
  case "$1" in
  -o | --outdir)
    [[ $# -ge 2 && -n "$2" ]] || die "Missing value for $1"
    OUT_DIR="$2"
    shift 2
    ;;
  -h | --help) usage && exit 0 ;;
  --) shift && break ;;
  -*) die "Unknown option: $1 (see --help)" ;;
  *) break ;;
  esac
done

INPUTS=("$@")

((${#INPUTS[@]})) || {
  usage >&2
  exit 2
}

if command -v soffice >/dev/null 2>&1; then
  SOFFICE=soffice
elif command -v libreoffice >/dev/null 2>&1; then
  SOFFICE=libreoffice
else
  die "LibreOffice not found in PATH (install libreoffice-fresh or the LibreOffice cask)"
fi

if [[ "$(uname -s)" == "Darwin" && -f /opt/homebrew/etc/fonts/fonts.conf ]]; then
  export FONTCONFIG_FILE=/opt/homebrew/etc/fonts/fonts.conf
  export FONTCONFIG_PATH=/opt/homebrew/etc/fonts
fi

if [[ -n "$OUT_DIR" ]]; then
  mkdir -p -- "$OUT_DIR" || die "Cannot create output directory: $OUT_DIR"
fi

for input in "${INPUTS[@]}"; do
  [[ -f "$input" ]] || die "Not a file: $input"
  case "$input" in
  *.pptx | *.ppt | *.PPTX | *.PPT) ;;
  *) die "Not a PowerPoint file: $input" ;;
  esac
done

profile_dir=$(mktemp -d "${TMPDIR:-/tmp}/pptx2pdf-lo.XXXXXX")
trap 'rm -rf -- "$profile_dir"' EXIT

convert_file() {
  local outdir="$1"
  shift
  "$SOFFICE" \
    "-env:UserInstallation=file://$profile_dir" \
    --headless \
    --convert-to pdf \
    --outdir "$outdir" \
    "$@"
}

if [[ -n "$OUT_DIR" ]]; then
  convert_file "$OUT_DIR" "${INPUTS[@]}"
else
  for input in "${INPUTS[@]}"; do
    convert_file "$(dirname -- "$input")" "$input"
  done
fi

printf 'PDF written:\n'
for input in "${INPUTS[@]}"; do
  target_dir="${OUT_DIR:-$(dirname -- "$input")}"
  basename=$(basename -- "$input")
  printf '  %s\n' "$target_dir/${basename%.*}.pdf"
done
