function clean_docker() {
  # $ docker help ps
  # -a, --all=false       Show all containers (default shows just running)
  # --before=             Show only container created before Id or Name
  # -f, --filter=[]       Filter output based on conditions provided
  # --format=             Pretty-print containers using a Go template
  # --help=false          Print usage
  # -l, --latest=false    Show the latest created container, include non-running
  # -n=-1                 Show n last created containers, include non-running
  # --no-trunc=false      Don't truncate output
  # -q, --quiet=false     Only display numeric IDs
  # -s, --size=false      Display total file sizes
  # --since=              Show created since Id or Name, include non-running

  # query all containers that have status = (exited|dead)
  CONTAINERS=$(docker ps \
    --all \
    --filter "status=exited" \
    --filter "status=dead" \
    --format="{{.ID}}")

  for CONTAINER in $CONTAINERS; do
    # get the container name and label
    NAME=$(docker ps \
      --all \
      --filter "id=$CONTAINER" \
      --format "{{.Names}} {{.Labels}}")

    read -p "You are about to delete $NAME Are you sure? (y/n)" -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo -n "Deleting $NAME..."

      docker rm $CONTAINER 2&>1 /dev/null

      echo " DELETED"
    fi
  done
}

# runs docker exec
function docker-exec {
  docker exec -ti $1 /bin/bash
}

# runs docker exec in the latest container
function docker-exec-last {
  docker exec -ti $( docker ps -a -q -l) /bin/bash
}

function docker-get-ip {
  # Usage: docker-get-ip (name or sha)
  [ -n "$1" ] && docker inspect --format "{{ .NetworkSettings.IPAddress }}" $1
}

function docker-get-id {
  # Usage: docker-get-id (friendly-name)
  [ -n "$1" ] && docker inspect --format "{{ .ID }}" "$1"
}

function docker-get-image {
  # Usage: docker-get-image (friendly-name)
  [ -n "$1" ] && docker inspect --format "{{ .Image }}" "$1"
}

function docker-get-state {
  # Usage: docker-get-state (friendly-name)
  [ -n "$1" ] && docker inspect --format "{{ .State.Running }}" "$1"
}

function docker-memory {
  for line in `docker ps | awk '{print $1}' | grep -v CONTAINER`; do docker ps | grep $line | awk '{printf $NF" "}' && echo $(( `cat /sys/fs/cgroup/memory/docker/$line*/memory.usage_in_bytes` / 1024 / 1024 ))MB ; done
}
# keeps the commmand history when running a container
function basher() {
    if [[ $1 = 'run' ]]
    then
        shift
        docker run -e HIST_FILE=/root/.bash_history -v $HOME/.bash_history:/root/.bash_history "$@"
    else
        docker "$@"
    fi
}
# backup files from a docker volume into /tmp/backup.tar.gz
function docker-volume-backup-compressed() {
  docker run --rm -v /tmp:/backup --volumes-from "$1" debian:jessie tar -czvf /backup/backup.tar.gz "${@:2}"
}
# restore files from /tmp/backup.tar.gz into a docker volume
function docker-volume-restore-compressed() {
  docker run --rm -v /tmp:/backup --volumes-from "$1" debian:jessie tar -xzvf /backup/backup.tar.gz "${@:2}"
  echo "Double checking files..."
  docker run --rm -v /tmp:/backup --volumes-from "$1" debian:jessie ls -lh "${@:2}"
}
# backup files from a docker volume into /tmp/backup.tar
function docker-volume-backup() {
  docker run --rm -v /tmp:/backup --volumes-from "$1" busybox tar -cvf /backup/backup.tar "${@:2}"
}
# restore files from /tmp/backup.tar into a docker volume
function docker-volume-restore() {
  docker run --rm -v /tmp:/backup --volumes-from "$1" busybox tar -xvf /backup/backup.tar "${@:2}"
  echo "Double checking files..."
  docker run --rm -v /tmp:/backup --volumes-from "$1" busybox ls -lh "${@:2}"
}

function docker-remove-log() {
  docker-machine ssh default "sudo rm $(docker inspect --format='{{.LogPath}}' $1)"
}
