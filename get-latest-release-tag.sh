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
latest_release_url="https://api.github.com/repos/${owner}/${repo}/releases/latest"

# Given a JSON input on stdin, extract the string value associated with the
# specified key. This avoids an extra dependency on a tool like `jq`.
extract() {
    local key="$1"
    # Extract "<key>":"<val>" (assumes key/val won't contain double quotes).
    # The colon may have whitespace on either side.
    grep -o "\"${key}\"[[:space:]]*:[[:space:]]*\"[^\"]\+\"" |
    # Extract just <val> by deleting the last '"', and then greedily deleting
    # everything up to '"'.
    sed -e 's/"$//' -e 's/.*"//'
}

# The API returns a JSON output like
#
# [...snip...]
#   "tag_name": "1.2.3",
# [...snip...]
#
# This output is usually (but for some reason, not always) pretty-printed.
#
curl -fsSL "${latest_release_url}" | extract 'tag_name'
