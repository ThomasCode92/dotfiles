# 🔑 GPG - Copying Keys to a New Machine

Use [`scripts/executable_transfer.sh`](../scripts/executable_transfer.sh) to
copy exported GPG keys to a new machine over SSH. The examples below use a Mac
as the source and a Linux machine as the target.

It **only copies files**: exporting keys, importing them, setting ownertrust,
and configuring GPG are separate steps. For script options, general file and
folder examples, and copy behavior, see the
[file-transfer guide](file-transfer.md).

## ✅ Prerequisites

- SSH access to the target, with its host key verified before transferring.
- `scp` and `ssh` installed locally.
- GnuPG installed locally to export keys, and on the target to import them.
  For a new machine, bootstrap can install GnuPG after the files are copied.
- The secret key available locally: `gpg --list-secret-keys --keyid-format=long`.

Run the examples from the repository root in Bash or Zsh. Replace the
fingerprint and host with your own values:

```sh
export KEY_FP=2986DF8BB6D470641BEEC134B4AAD4042299EF69
export LINUX_HOST=thomas@linux-box.local
```

An SSH alias or `user@ip` works too. If `.local` name resolution fails, use the
machine's IP address.

## 🚀 Export and Copy the Key Files

Skip the export commands if you already have the desired `privatekey.asc` and
`publickey.asc`. Do not overwrite existing exports unless you intend to replace
them.

```sh
# Restrict permissions when creating exported files.
(
  umask 077
  gpg --export-secret-keys --armor "$KEY_FP" > "$HOME/privatekey.asc"
  gpg --export --armor "$KEY_FP" > "$HOME/publickey.asc"
)

# Also restrict any files that already existed before the export.
chmod 600 "$HOME/privatekey.asc" "$HOME/publickey.asc"

./scripts/executable_transfer.sh "$LINUX_HOST" \
  "$HOME/privatekey.asc" "$HOME/publickey.asc"
```

GPG may prompt for the key's passphrase during export. File transfer itself
does not use GPG or prompt for a GPG passphrase.

The script copies both files into the remote user's home directory, preserving
their names, permissions, and timestamps. It prints the planned copies and
asks for confirmation. Matching destination files are overwritten.

### Option A: Bootstrap a New Machine

Leave the files at `~/privatekey.asc` and `~/publickey.asc` on the target, then
follow the [README setup instructions](../README.md).
The bootstrap scripts import those filenames from the target's home directory.
Do not use a custom destination directory for this workflow.

The transfer script does not run bootstrap or delete the exported files.
After setup succeeds, follow the cleanup section below.

### Option B: Import on an Existing Machine

If GnuPG is already installed on the target:

```sh
ssh "$LINUX_HOST" \
  'gpg --batch --import "$HOME/publickey.asc" "$HOME/privatekey.asc"'
```

Ownertrust is separate from the key exports. To copy the trust setting for
this key only:

```sh
gpg --export-ownertrust |
  awk -F: -v fpr="$KEY_FP" '$1 == fpr' |
  ssh "$LINUX_HOST" gpg --import-ownertrust
```

Use the full fingerprint in `KEY_FP`. If the local key has no ownertrust entry,
this command has no trust setting to transfer. Only mark a key ultimately
trusted when you have verified that it is your own key.

## 📦 Using Existing GPG Backups

[`scripts/executable_gpg-backup.sh`](../scripts/executable_gpg-backup.sh)
exports keys under `gpg-backup/<timestamp>/`. It uses names such as
`all-private-keys.asc` / `all-public-keys.asc`, or
`private-key-<id>.asc` / `public-key-<id>.asc`.

The transfer script preserves those names. For bootstrap, manually stage the
desired exports as `privatekey.asc` and `publickey.asc` before copying. Prefer
exports of just the required key rather than sending every secret key.

Do **not** copy `~/.gnupg` or the backup's `gnupg-config` folder wholesale.
They can contain agent sockets, keybox state, and host-specific settings.
Transfer the exported key files instead. If using a backup's `ownertrust.txt`,
remember that it may contain trust settings for multiple keys.

## 🔍 Verify the Imported Key

After bootstrap or manual import, compare the fingerprints on both machines
and confirm that the target lists the secret key:

```sh
gpg --fingerprint "$KEY_FP"
ssh "$LINUX_HOST" gpg --fingerprint "$KEY_FP"
ssh "$LINUX_HOST" gpg --list-secret-keys --keyid-format=long "$KEY_FP"
```

For [pass](https://www.passwordstore.org/), the target also needs access to
your password store. Once the store is present, initialize it with the key:

```sh
ssh "$LINUX_HOST" pass init "$KEY_FP"
```

Test decryption of an existing entry interactively on the target before
removing the exported files. Never delete the original keyring as part of
transfer cleanup.

## 🧹 Cleanup and Security

After confirming that import or bootstrap succeeded, remove the exported
copies from both machines:

```sh
ssh "$LINUX_HOST" 'rm -f "$HOME/privatekey.asc" "$HOME/publickey.asc"'
rm -f "$HOME/privatekey.asc" "$HOME/publickey.asc"
```

- SSH encrypts the transfer; verify the host key to avoid sending secrets to
  the wrong machine.
- Keep exported secret keys out of Git, cloud sync, and unencrypted backups.
- File deletion, including `shred`, does not guarantee secure erasure on SSDs,
  copy-on-write filesystems, snapshots, or backups. Use encrypted storage.
- Never supply a GPG passphrase on the command line. Let pinentry prompt.

## 🩺 Troubleshooting

- **File transfer fails:** see the
  [file-transfer troubleshooting section](file-transfer.md#-troubleshooting).
- **Bootstrap cannot find the keys:** stage them with the exact names
  `privatekey.asc` and `publickey.asc` in the remote home directory.
- **Pinentry cannot find a terminal:** run the GPG operation interactively. In
  Bash/Zsh, set `export GPG_TTY=$(tty)`; in Fish, use `set -gx GPG_TTY (tty)`.
  Changing the transfer options will not fix a GPG export error.
- **No secret key after copying:** copying does not import keys. Run bootstrap
  or the manual import command, then list the target's secret keys again.
- **Key expired or not trusted:** inspect the key's expiry and ownertrust in
  GPG. Neither is changed by the file transfer script.
