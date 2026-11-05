# 📂 Transferring Files Between Machines

[`scripts/executable_transfer.sh`](../scripts/executable_transfer.sh) copies
local files and folders to another machine over SSH using `scp`.

It only copies files. It does not rename them, remove the originals, or run
setup commands on the target. It replaces the former `gpg-transfer.sh` and
`gpg-deploy-files.sh` scripts, but does not require GPG.

For a key-transfer walkthrough, see
[Copying GPG Keys to a New Machine](gpg-linux-transfer.md).

## ✅ Prerequisites

- `scp` and `ssh` installed locally.
- SSH access to the target; verify its host key before transferring.
- An existing, writable destination directory on the target.

Run the examples from the repository root. Replace `user@host` with your
destination, such as `thomas@linux-box.local`, `user@ip`, or an SSH alias.

## 🚀 Usage

```text
./scripts/executable_transfer.sh [options] <user@host> <file-or-directory> [...]
```

Put options **before the host**, followed by one or more explicit local paths.
Quote paths containing spaces.

```sh
# Copy several files to the remote home directory.
./scripts/executable_transfer.sh user@host ./report.pdf ./notes.txt

# Copy a whole folder into an existing remote directory.
./scripts/executable_transfer.sh -d Documents user@host "./project notes"

# Use an absolute remote destination.
./scripts/executable_transfer.sh -d /srv/backups user@host ./backup

# Preview the command without connecting or copying.
./scripts/executable_transfer.sh -n user@host "./project notes"

# Skip the confirmation prompt.
./scripts/executable_transfer.sh -y user@host ./report.pdf
```

Without `--yes`, the script prints the planned copies, warns about overwriting,
and asks for confirmation. Answer `y` to proceed; otherwise it exits without
copying.

## ⚙️ Options

| Option                      | Behavior                                       |
| --------------------------- | ---------------------------------------------- |
| `-d`, `--destination <dir>` | Existing remote directory; defaults to home.   |
| `-y`, `--yes`               | Skip confirmation.                             |
| `-n`, `--dry-run`           | Print the command without a remote connection. |
| `-h`, `--help`              | Show usage and examples.                       |

## 📋 Copy Behavior

- Relative destinations such as `Documents` mean `~/Documents` on the target.
  The destination must already exist and be writable.
- Folders are copied recursively, including hidden files. `./notes` copied into
  `Documents` becomes `~/Documents/notes`.
- Existing folders are merged; matching files are overwritten. Unrelated
  destination files are not deleted.
- Source names, permissions, and timestamps are preserved. Ownership is not
  preserved.
- Symbolic links are followed: their targets are copied, not the links.
- Source files remain in place. There is no automatic cleanup, renaming, GPG
  setup, or separate checksum verification.

## 🔒 Sensitive Files

SSH encrypts the transfer, but verify the host key to avoid sending files to the
wrong machine. Permissions are preserved; the script does not automatically set
sensitive files to mode `600`.

For example, restrict a private file before copying:

```sh
chmod 600 ./private-file
./scripts/executable_transfer.sh user@host ./private-file
```

## 🩺 Troubleshooting

- **Transfer fails:** check SSH access, the hostname, and whether the remote
  destination exists and is writable. The script does not create directories.
- **Local file not found:** provide the full path or run from the correct
  directory. The script does not search for files automatically.
- **Options treated as filenames:** place options before the host.
- **`.local` hostname does not resolve:** use the machine's IP address or a
  configured SSH alias.
