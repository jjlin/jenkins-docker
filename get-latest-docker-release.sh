#!/bin/bash
################################################################################
#
# Get the latest Docker release for a specified channel.
#
###############################################################################

if [[ $# -gt 1 ]] || [[ "$1" == "-h" ]]; then
    echo "usage: $0 [channel=<edge|stable>]"
    echo
    echo "If no channel is specified, default to 'edge'."
    exit 1
fi

channel="edge"
if [ $# -eq 1 ]; then
    channel="$1"
fi

curl -sSL "https://download.docker.com/linux/static/${channel}/x86_64/" |
    # Strip out HTML tags.
    sed 's/<[^>]*>//g' |
    # Extract the tarball names.
    egrep -o 'docker-.*-ce\.tgz' |
    # Extract the versions.
    egrep -o '[[:digit:]].*-ce' |
    # Sort and return the latest version.
    sort |
    tail -n1
