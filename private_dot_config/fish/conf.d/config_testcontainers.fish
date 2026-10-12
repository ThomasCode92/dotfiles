# Set environment variables for Testcontainers when using Colima-managed Docker
# For more information, see https://java.testcontainers.org/supported_docker_environment/#colima
# Erase any inherited global DOCKER_HOST from the parent environment

if command -v colima >/dev/null; and colima status >/dev/null 2>&1
    if not test -L /var/run/docker.sock
        echo "⚠️  Warning: /var/run/docker.sock is not a symlink."
        echo "    Run the following command to create the symlink:"
        echo "    sudo ln -sf $HOME/.colima/default/docker.sock /var/run/docker.sock"
    end

    set -Ux TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE /var/run/docker.sock
    set -Ux TESTCONTAINERS_HOST_OVERRIDE (colima ls -j | jq -r '.address')
else
    set -e TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE
    set -e TESTCONTAINERS_HOST_OVERRIDE
end

set -e TESTCONTAINERS_RYUK_DISABLED
