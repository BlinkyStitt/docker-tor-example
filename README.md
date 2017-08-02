# Docker Compose Tor Example

Example docker-compose file and entrypoint script for running docker containers behind Tor.

Usage:

    docker-compose pull
    docker-compose build --pull
    docker-compose up

To get a shell in a backend app container:

    docker-compose run backend sh

Note: Using `docker-compose exec` bypasses the entrypoint where Tor setup happens

Inside the shell, all your commands will be behind Tor:

    curl -sN https://check.torproject.org/ | grep -m 1 Congratulations
