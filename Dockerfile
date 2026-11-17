ARG BASE_IMAGE=lopsided/archlinux:latest
FROM ${BASE_IMAGE}

# disable sandbox
RUN sed -i 's/^#\?DisableSandbox.*//' /etc/pacman.conf \
  && sed -i '/^\[options\]/a DisableSandbox' /etc/pacman.conf

# sudo is needed by bootstrap-arch.sh; use a normal user like on a real machine
RUN pacman -Syu --noconfirm sudo \
  && useradd -m -G wheel dev \
  && echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel

USER dev

# Keep the scripts outside ~/.local/share/chezmoi so that `chezmoi init` can
# clone into an empty source directory, like on a real machine.
COPY --chown=dev:dev bootstrap.sh bootstrap-macos.sh bootstrap-arch.sh /opt/dotfiles/

# Run from the user's home (writable), matching a real machine.
WORKDIR /home/dev

# Use the copied scripts (no download). Override at runtime with
# `-e DOTFILES_LOCAL=0` to test the download path.
ENV DOTFILES_LOCAL=1
ENV DOTFILES_SCRIPT_DIR=/opt/dotfiles

ENTRYPOINT ["bash", "/opt/dotfiles/bootstrap.sh"]
