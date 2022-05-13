# Docker PHP-FPM 7.0 & Nginx 1.20 on Alpine Linux
Example PHP-FPM 7.0 & Nginx 1.20 container image for Docker, built on [Alpine Linux](https://www.alpinelinux.org/).

## Goal of this project
The goal of this container image is to provide an example for running Nginx and PHP-FPM in a container with downloaded
composer & project from private repository.

## Usage
Start the Docker container:

    docker compose up -d

View in browser:
    
    http://localhost:8081
    
Enter the container:

    docker exec -it myproject sh

## Configuration
Change REPOSITORY_DOMAIN & REPOSITORY_URL in Dockerfile for your project.<br>
Don't forget to change document root of the project in config/nginx.conf<br>
PHP8 also can be installed, change apk`s for php8 and uncomment symlink command.<br>
Project can be copied from src directory too.