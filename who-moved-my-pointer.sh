#!/bin/bash
COMMIT_FILTER='^Merge'
MAX_HISTORY='-50'

function print_help() {
  echo "Usage: $0 <module-name> [<commit> <base-commit>]"
  echo "Optional flags: "
  echo "    -h             print help"
  echo "    -m <number>    maximum number of commits to list"
  echo "    -a             include all toplevel commits which changed the submodule's pointer (by default only merges)"
  echo "    -f <format>    format of notes"
  echo
}

while [ $# -gt 0 ]; do
  KEY="$1"
  case $KEY in
  -h|--help)
    print_help
    exit 1
    ;;
  -m|--max)
    MAX_HISTORY="-$2"
    shift # past argument
    ;;
  -a|--all)
    COMMIT_FILTER='commit'
    ;;
  -f|--format)
    FORMAT="$2"
    shift # past argument
    ;;
  *)
    if [ -z "$MODULE" ]; then
      MODULE="$1"
    elif [ -z "$DIFF_COMMIT"]; then
      DIFF_TOPLEVEL="$1"
    else
      BASE_TOPLEVEL="$1"
    fi
  esac
  shift
done

if [ -z "$FORMAT" ]; then
  FORMAT="%ar, %Cred%an%Creset"
fi

if [ -z $MODULE ] || [ -n "$DIFF_TOPLEVEL" -a -z "$BASE_TOPLEVEL" ]; then
  print_help
  exit 1
fi

MODULE_PATH=`git submodule -q foreach 'echo $MODULE; if [ \`basename $name\` == "'$MODULE'" ]; then echo $path; fi'`
MODULE_PATH=$(echo $MODULE_PATH)

if [ -n "$2" -a -n "$3" ]; then
  DIFF_COMMIT=`git rev-parse $DIFF_TOPLEVEL:$MODULE_PATH`
  BASE_COMMIT=`git rev-parse $BASE_TOPLEVEL:$MODULE_PATH`
  echo "$DIFF_TOPLEVEL -> $DIFF_COMMIT"
  echo "$BASE_TOPLEVEL -> $BASE_COMMIT"
  git diff --color=always --submodule=log $2 $3 -- $MODULE_PATH
  echo -----------------------------------------------------------
  git -C $MODULE_PATH diff --color=always $DIFF_COMMIT $BASE_COMMIT
  exit $?
fi


echo "toplevel                                 -> $MODULE_PATH ( merged by )"
LAST_POINTER=
for i in `git log | grep $COMMIT_FILTER -B 1 | grep commit | awk '{print $2}' | head $MAX_HISTORY`; do 
  NEW_POINTER=`git rev-parse $i:$MODULE_PATH 2> /dev/null`
  if [ $? -ne 0 ]; then
    echo $i "-> submodule not found"
  elif [ "$LAST_POINTER" != "$NEW_POINTER" ]; then
    pushd $MODULE_PATH > /dev/null
    MODULE_POINTER_INFO="(`git show --pretty="format:$FORMAT"  --name-only $NEW_POINTER | head -1`)"
    popd > /dev/null
    TOPLEVEL_INFO="(`git show --pretty="format:$FORMAT"  --name-only $i | head -1`)" 
    echo $i "$TOPLEVEL_INFO" "->" $NEW_POINTER "$MODULE_POINTER_INFO"
  fi
  LAST_POINTER=$NEW_POINTER
done
