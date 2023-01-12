#!/bin/bash

# {{{ parsing kwargs
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --source)
    source="$2"
    shift # past argument
    shift # past value
    ;;
    --target)
    target="$2"
    shift # past argument
    shift # past value
    ;;
    --author)
    author="$2"
    shift # past argument
    shift # past value
    ;;
    --commit_message)
    commit_message="$2"
    shift # past argument
    shift # past value
    ;;
    --branches)
    branches="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    echo "Unknown option $1"
    exit 1
    ;;
esac
done

if [ -z "$author" ]; then
  author=""
fi

if [ -z "$commit_message" ]; then
  commit_message=''
fi

if [ -z "$source" ]; then
  echo "source repository not provided, please provide a source repository path with --source=<path>"
  exit 1
fi

if [ -z "$target" ]; then
  echo "target repository not provided, please provide a target repository path with --target=<path>"
  exit 1
fi
# }}}

# Initialize the target folder as a git repository
mkdir -p $target
cd $target
git init

if [ -z "$branches" ]; then
  # Copy all commits from the source repository to the target repository
  # Only the dates and author are copied
  git --git-dir=$source/.git log --pretty=format:%ad --author="$author" \
  | while read -r cdate ; do
    git commit --date="$cdate" --author="$author" --allow-empty \
      --allow-empty-message -m "$commit_message"
  done
else
  IFS=' ' read -ra branch_list <<< "$branches"
  for branch in "${branch_list[@]}"; do
    # Copy the commits from the specified branch in the source repository to the target repository
    # Only the dates and author are copied
    git --git-dir=$source/.git rev-list \
      $branch --author="$author"\
      | git --git-dir="$source"/.git name-rev --stdin \
      | sed -E "s/~[0-9]+//g; s/\^[0-9]+//g" \
      | grep " <$branch>" \
      | awk -F " " '{print $1}' \
      | while read -r commit_hash ; do
        cdate=$(git --git-dir=$source/.git show -s --format=%ad $commit_hash)
        git commit --date="$cdate" --author="$author" --allow-empty \
          --allow-empty-message -m "$commit_message"
    done
  done
fi
