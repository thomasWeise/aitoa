#!/bin/sh -f
# Trigger a new Travis-CI job.
# Usage:
# trigger-travis.sh [--pro] [--branch BRANCH] GITHUBID GITHUBPROJECT TRAVIS_ACCESS_TOKEN [MESSAGE]
# For example:
# trigger-travis.sh typetools checker-framework `cat ~/private/.travis-access-token` "Trigger for testing"
# For full documentation, see
# https://github.com/plume-lib/trigger-travis/tree/documentation
if [ "$#" -lt 3 ] || [ "$#" -ge 7 ]; then
echo "Wrong number of arguments $# to trigger-travis.sh; run like:"
echo " trigger-travis.sh [--pro] [--branch BRANCH] GITHUBID GITHUBPROJECT TRAVIS_ACCESS_TOKEN [MESSAGE]" >&2
exit 1
fi
if [ "$1" = "--pro" ] ; then
TRAVIS_URL=travis-ci.com
shift
else
TRAVIS_URL=travis-ci.org
fi
if [ "$1" = "--branch" ] ; then
shift
BRANCH="$1"
shift
else
BRANCH=master
fi
USER=$1
REPO=$2
TOKEN=$3
if [ $# -eq 4 ] ; then
MESSAGE=",\"message\": \"$4\""
elif [ -n "$TRAVIS_REPO_SLUG" ] ; then
MESSAGE=",\"message\": \"Triggered by upstream build of $TRAVIS_REPO_SLUG commit "`git log --oneline -n 1 HEAD`"\""
else
MESSAGE=""
fi
## For debugging:
# echo "USER=$USER"
# echo "REPO=$REPO"
# echo "TOKEN=$TOKEN"
# echo "MESSAGE=$MESSAGE"
body="{
\"request\": {
\"branch\":\"$BRANCH\"
$MESSAGE
}}"
# It does not work to put / in place of %2F in the URL below. I'm not sure why.
curl -s -X POST \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
-H "Travis-API-Version: 3" \
-H "Authorization: token ${TOKEN}" \
-d "$body" \
https://api.${TRAVIS_URL}/repo/${USER}%2F${REPO}/requests \
| tee /tmp/travis-request-output.$$.txt
if grep -q '"@type": "error"' /tmp/travis-request-output.$$.txt; then
exit 1
fi
if grep -q 'access denied' /tmp/travis-request-output.$$.txt; then
exit 1
fi
# 
# Originally, I planned to using this file by copying it on the fly from its
# source, https://github.com/plume-lib/trigger-travis.
# But this would be a security risk, as a change to that file could lead to
# the leakage of my travis access token.
# So I decided to use a copy here.
#
# The original file is under the MIT License, which is copied here.
#
# MIT License
# Copyright (c) 2018 plume-lib
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.