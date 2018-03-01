#!/bin/bash
if [ -z "$FORMAT" ]; then
  FORMAT="%ar, %Cred%an%Creset"
fi

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


echo "toplevel                                 -> $MODULE_PATH ( merged by )"
LAST_POINTER=
for i in `git log | grep ^Merge -B 1 | grep commit | awk '{print $2}' | head -50`; do 
  NEW_POINTER=`git rev-parse $i:$MODULE_PATH`
  if [ "$LAST_POINTER" != "$NEW_POINTER" ]; then
    pushd $MODULE_PATH > /dev/null
    MODULE_POINTER_INFO="(`git show --pretty="format:$FORMAT"  --name-only $NEW_POINTER | head -1`)"
    popd > /dev/null
    TOPLEVEL_INFO="(`git show --pretty="format:$FORMAT"  --name-only $i | head -1`)" 
    echo $i "$TOPLEVEL_INFO" "->" $NEW_POINTER "$MODULE_POINTER_INFO"
  fi
  LAST_POINTER=$NEW_POINTER
done
