clean_docker() {
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