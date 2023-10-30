#!/usr/bin/env zsh

set -o ERR_EXIT

cd "$0:A:h"

if [ -z "$(git status --porcelain=v2)" ]; then
	exit 0
fi

if [ -z "$(diff <(git cat :community-plugins.json | jq) <(jq <community-plugins.json))" ]; then
	git restore -W -- community-plugins.json
fi

files_with_bogous_changes=(
	plugins/novel-word-count/data.json
	appearance.json
)

for f in "${files_with_bogous_changes[@]}"; do
	[ -z "$(git diff "$f")" ] && git add "$f"
done

git status
