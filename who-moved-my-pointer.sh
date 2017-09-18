#!/bin/bash
MODULE=$1
if [ -z $MODULE ] || [ -n "$2" -a -z "$3" ]; then
  echo "Usage: $0 <module-name> [<commit> <base-commit>]"
  exit 1
fi

MODULE_PATH=`git submodule -q foreach 'echo $MODULE; if [ \`basename $name\` == "'$MODULE'" ]; then echo $path; fi'`
MODULE_PATH=$(echo $MODULE_PATH)

if [ -n "$2" -a -n "$3" ]; then
  DIFF_COMMIT=`git rev-parse $2:$MODULE_PATH`
  BASE_COMMIT=`git rev-parse $3:$MODULE_PATH`
  echo "$2 -> $DIFF_COMMIT"
  echo "$3 -> $BASE_COMMIT"
  git diff --color=always --submodule=log $2 $3 -- $MODULE_PATH
  echo -----------------------------------------------------------
  git -C $MODULE_PATH diff --color=always $DIFF_COMMIT $BASE_COMMIT
  exit $?
fi


echo Listing for $MODULE_PATH
for i in `git log | grep Merge -B 1 | grep commit | awk '{print $2}' | head -50`; do echo $i "->" `git rev-parse $i:$MODULE_PATH` "(" `git show --pretty="format:%an"  --name-only $i | head -1` ")" ; done
