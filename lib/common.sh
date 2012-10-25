
VERSION="0.0.3"

# If $BB_INSTALL is not defined
#  then it will be set to $MAIN_DIR
#  The $MAIN_DIR variable is set in
#  bin/bb
if [ -z "$BB_INSTALL" ]
then 
  BB_INSTALL=$MAIN_DIR
fi


# Common Paths that can be used
#  inside recipes to point to
#  installation locations.
TB_DIR="$BB_INSTALL/stage"
STAGE_DIR="$BB_INSTALL/stage"

LOCAL_DIR="$BB_INSTALL"

BIN_DIR="$LOCAL_DIR/bin"
SBIN_DIR="$LOCAL_DIR/sbin"
ETC_DIR="$LOCAL_DIR/etc"
INCLUDE_DIR="$LOCAL_DIR/include"
LIB_DIR="$LOCAL_DIR/lib"
LIB64_DIR="$LOCAL_DIR/lib64"
LIBEXEC_DIR="$LOCAL_DIR/libexec"
MAN_DIR="$LOCAL_DIR/man"
SHARE_DIR="$LOCAL_DIR/share"

# bio.brew specific paths
RECIPE_DIR="$MAIN_DIR/recipes"
RESOURCES_DIR="$MAIN_DIR/resources"
LOG_DIR="$MAIN_DIR/logs"

#===============================================
#    NAME: version
#    DESC: displays version number then exits
# PARAM 1: --
#   
#===============================================
version()
{
  echo $VERSION
  bye 0
}

#===============================================
#    NAME: bye
#    DESC: exits with specified status
# PARAM 1: the status to exit with
#   
#===============================================
bye()
{
  exit $1
}

#===============================================
#    NAME: check_recipe
#    DESC: attempts to find recipe in $RECIPE_DIR
#          if not found, then usage is displayed
#          and program exits
# PARAM 1: the recipe name to look for
#   
#===============================================
check_recipe()
{
  if [ ! -f $RECIPE_DIR/$1 ]  
  then
    usage 1 "recipe not found."
  fi
}

#===============================================
#    NAME: log
#    DESC: outputs string with timestamp to STDOUT
# PARAM 1: the log message
# PARAM 2: if present, program will exit with 
#          this status
#   
#===============================================
log()
{
  local log_msg=$1
  local log_and_go=$2
  echo "`date` >> $1"
  [ ".$log_and_go" != "." ] && exit $log_and_go
  return 0
}

#===============================================
#    NAME: extract_tool_name
#    DESC: attempts to determine tool/recipe name
#          given a archive file name and file type
# PARAM 1: the tool's archive file name
# PARAM 2: the type (zip, tar, etc) of the archive
#   
#===============================================
extract_tool_name()
{
  local tb_file=$1
  local type=$2
  echo `echo $tb_file | sed "s/.$type//g"`
}

#===============================================
#    NAME: find_dist_path
#    DESC: searches down a path for a target file
#          can follow symlinks
# PARAM 1: the full file path of the target file
#
#  SOURCE: http://stackoverflow.com/questions/1055671/how-can-i-get-the-behavior-of-gnus-readlink-f-on-a-mac 
#   
#===============================================
find_dist_path()
{
  local target_file=$1
  cd `dirname $target_file`
  cd ..
  target_file=`basename $target_file`

  # Iterate down a (possible) chain of symlinks
  while [ -L "$target_file" ]
  do
      target_file=`readlink $target_file`
      cd `dirname $target_file`
      target_file=`basename $target_file`
  done

  result=`pwd -P`/$target_file
  echo $result
}
