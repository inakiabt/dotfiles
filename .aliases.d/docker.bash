alias dockercleancontainers="docker ps -aq | xargs docker rm"
alias dockercleanimages="docker images -aq -f dangling=true | xargs docker rmi"
alias dockerclean="dockercleancontainers && dockercleanimages && clean_docker"
alias docker-killall="docker ps -q | xargs docker kill"

# lint a Dockerfile: https://github.com/lukasmartinelli/hadolint/
alias hadolint="docker run --rm -i lukasmartinelli/hadolint"
alias dockerfile-lint="hadolint"