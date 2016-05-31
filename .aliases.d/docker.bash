alias docker-clean-containers="docker ps -aq | xargs docker rm"
alias docker-clean-images="docker images -aq -f dangling=true | xargs docker rmi"
alias docker-clean="dockercleancontainers && dockercleanimages && clean_docker"
alias docker-killall="docker ps -q | xargs docker kill"

# lint a Dockerfile: https://github.com/lukasmartinelli/hadolint/
alias hadolint="docker run --rm -i lukasmartinelli/hadolint"
alias dockerfile-lint="hadolint"