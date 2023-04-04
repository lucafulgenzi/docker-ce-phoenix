#!/bin/bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)"
data_dir="${script_dir}/data"
temp_dir="${script_dir}/temp"

volume_exist() {
    if [ -d "$data_dir" ] || [ $(docker volume ls -f name=ce-phoenix-volume | awk '{print $NF}' | grep -E '^'$1'$') ];
    then
        return 0
    else
        return 1
    fi
}


usage() {
  cat <<EOF
      Usage: [-h] [-p] [-d]
      Available options:
      -h, --help          Print this help and exit
      -s, --start          Generate .jar file for all services
      -d, --dev           Generate .jar file for develop services ( discovery, api-gateway )
      --discovery         Generate .jar file for discovery service
      --apigateway        Generate .jar file for api-gateway service
      --authorization     Generate .jar file for authorization service
      --registry        Generate .jar file for registry service
      --consiliabm        Generate .jar file for consiliabm service
EOF
  exit
}

cleanup() {
    trap - SIGINT SIGTERM ERR EXIT
}

setup_colors() {
    if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then

        GREEN='\033[0;32m'
        ORANGE='\033[0;33m'
        BLUE='\033[0;34m'
        PURPLE='\033[0;35m'
        CYAN='\033[0;36m'
        YELLOW='\033[1;33m'
    else
        NOFORMAT=''
        RED=''
        GREEN=''
        ORANGE=''
        BLUE=''
        PURPLE=''
        CYAN=''
        YELLOW=''
    fi
}

msg() {
    echo >&2 -e "${1-}"
}

die() {
    local msg=$1
    local code=${2-1}
    msg "$msg"
    exit "$code"
}

remove_docker_volumes(){
    msg "Removing docker volumes..."
    sudo docker volume rm ce-phoenix-volume
    rm -rf "${data_dir}" "${temp_dir}"
}


create_docker(){
    remove_docker_volumes

    mkdir "${temp_dir}"
    mkdir "${data_dir}"

    msg "Downloading ce-phoenix-cart..."
    wget -nv -O "${temp_dir}/ce-phoenix-cart.zip" https://github.com/CE-PhoenixCart/PhoenixCart/archive/master.zip

    msg "Unzip ce-phoenix-cart..."
    unzip -q "${temp_dir}/ce-phoenix-cart.zip" -d "${temp_dir}/ce-phoenix-cart-temp"

    mv "${temp_dir}/ce-phoenix-cart-temp/PhoenixCart-master"/* "${data_dir}"
    rm -rf "${temp_dir}"

    sudo docker volume create ce-phoenix-volume

    sudo docker-compose up --build -d
}


start(){
    if volume_exist;
    then
        sudo docker-compose up -d
    else
        create_docker
    fi
}

destroy_docker(){
    sudo docker-compose down -v
}



parse_params() {
    while :; do
        case "${1-}" in
            -h | --help) usage ;;
            -s | --start) start ;;
            -c | --create) create_docker ;;
            -d | --down) destroy_docker ;;
            -?*) die "Unknown option: $1" ;;
            *) break ;;
        esac
        shift
    done

    return 0
}

parse_params "$@"
setup_colors
