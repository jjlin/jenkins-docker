#!/bin/bash
################################################################################
#
# Get the latest release tag for a repo using the GitHub API:
#
# <https://developer.github.com/v3/repos/releases/#get-the-latest-release>
#
###############################################################################

if [ $# -ne 2 ]; then
    echo "usage: $0 <owner> <repo>"
    exit 1
fi

owner="$1"
repo="$2"

# The API returns an output like
#
# [...snip...]
#   "tag_name": "1.2.3",
# [...snip...]
#
# To extract "1.2.3", we delete (1) everything up to and including ':',
# (2) whitespace and '"' from the front, and (3) ',' and '"' from the back.
#
curl -sSL https://api.github.com/repos/"${owner}"/"${repo}"/releases/latest \
    | grep 'tag_name' \
    | sed -e 's/[^:]\+://' -e 's/^[ "]\+//' -e 's/[,"]\+$//'
