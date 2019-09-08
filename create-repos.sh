#!/bin/bash
if [ $# -lt 2 ]; then
   echo "Usage: $0 RepoName RepoDescription"
   exit 1
fi
TOKEN=2b429bc78a37e8b3fa7887239211745694d29d7b
REPO_NAME=$1; shift
REPO_DESCRIPTION="$@"
curl -i -X POST https://api.github.com/user/repos \
-H "Authorization: token $TOKEN" \
-d @- << EOF
{
  "name": "$REPO_NAME",
  "description":"$REPO_DESCRIPTION",
  "auto_init": true,
  "private": false,
  "gitignore_template": "nanoc"
}
EOF
