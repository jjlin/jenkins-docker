#!/bin/bash
################################################################################
#
# Get the latest Docker release for a specified channel.
#
###############################################################################

if [[ $# -gt 1 ]] || [[ "$1" == "-h" ]]; then
    echo "usage: $0 [channel=<stable|test|nightly>]"
    echo
    echo "If no channel is specified, default to 'stable'."
    exit 1
fi

channel="stable"
if [ $# -eq 1 ]; then
    channel="$1"
fi

curl -sSL "https://download.docker.com/linux/static/${channel}/x86_64/" |
    # Strip out HTML tags.
    sed 's/<[^>]*>//g' |
    # Extract the tarball names.
    egrep -o 'docker-[0-9]+.*\.tgz' |
    # Extract the versions.
    sed -e 's/^docker-//' -e 's/\.tgz$//' |
    # Version-sort and return the latest version.
    sort -V |
    tail -n1
