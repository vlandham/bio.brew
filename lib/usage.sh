usage()
{
  e_code=$1
  e_msg=$2

  if [ ".$e_msg" != "." ]; then
    echo "ERROR: $e_msg"
    echo ""
  fi

  cat << EOF
VERSION : $VERSION
MAIN_DIR: $MAIN_DIR

bb (BioBrew) is a tiny and personal package manager that allows you 
to quickly setup your toolbox in a new (and perhaps hostile) environment.

bb also tries to focus on bio informatics tools (bfast, samtools, bwa, 
picard tools, ...)  as well as crucial UNIX tools (vim, cdargs, etc ...).

Usage: bb [-v] [-h] COMMAND [recipe]

COMMANDS:
  list     : list all the available recipes. 
           : use 'list installed' for only installed recipes.
  install  : install recipe.
  remove   : remove recipe.
  test     : run recipe tests.
  activate : make this recipe live.
  fake     : pretend to install this recipe.
  clean    : USE WITH CAUTION!
             remove all traces of a recipe/program. 
             Useful when testing a recipe.

OPTIONS:
  -v: print version.
  -h: print help.
  -j: Controls make -j parameter.
EOF

  bye $e_code
}

