#===============================================
#    NAME: bb_install
#    DESC: main entry point for recipe installation.
#          sources recipe file.
# PARAM 1: name of recipe to install
#   
#===============================================
bb_install()
{
  local recipe=$1
  local bb_action="install"
  log "Installing recipe: $recipe"
  check_recipe ${recipe}.sh
  log "recipe script found"
  source "$RECIPE_DIR/${recipe}.sh"
}

#===============================================
#    NAME: check_deps
#    DESC: ensures that all dependencies listed
#          in the $deps variable are installed.
#          Called by lib/case.sh.
# PARAM 1: deps array. 
#   
#===============================================
check_deps()
{
  local list_deps=("$@")
  local not_installed=""
  for f in ${list_deps[@]} 
  do
    local base_log=`dirname $LOG_DIR`
    local install_flag="$base_log/$f/*.installed"
    [ ! -f $install_flag ] && not_installed="$not_installed $f"
  done
  [ ".$not_installed" != "." ] && log "Install deps first:$not_installed" && exit 1
  return 0 
}

#===============================================
#    NAME: check_external_deps
#    DESC: ensures that all external dependencies listed
#          in the $external_deps variable are installed.
#          Called by lib/case.sh.
# PARAM 1: external_deps array. 
#   
#===============================================
check_external_deps()
{
  local list_external_deps=("$@")
  local not_installed=""

  for f in ${list_external_deps[@]}
  do
    log "Checking external dependency $f"
    if [ $(check_if_external_installed $f) == "0" ]
    then
      not_installed="$not_installed $f"
    fi
  done

  [ ".$not_installed" != "." ] && log "Install external packages first:$not_installed" && exit 1
  return 0
}

#===============================================
#    NAME: check_if_external_installed
#    DESC: attempts to determine if package is
#          installed external to bb.
#          Returns 1 if tool is installed, else 0.
#          Uses simple 'which <tool>' to determine
#          if installed.
# PARAM 1: package name
#   
#===============================================
check_if_external_installed()
{
  local program=$1
  local rtn=0 

  local program_found=`which ${program} 2> /dev/null`

  if [ ".$program_found" != "."  ]
  then
    local program_base_check=`basename ${program_found}`
    if [ "$program_base_check" == "$program" ]
    then
      rtn=1
    fi
  else
    rtn=0
  fi
  
  # 1 if installed
  # 0 if not installed
  echo $rtn
}

#===============================================
#    NAME: check_if_installed
#    DESC: checks if bb recipe has been installed
# PARAM 1: recipe name
#   
#===============================================
check_if_installed()
{
  local install_seed_name=$1
  [ -f $LOG_DIR/$install_seed_name.installed ] && echo 1 || echo 0
}

#===============================================
#    NAME: check_any_installed
#    DESC: returns 1 if a recipe has at least one
#          version installed. 
#          Called by lib/list.sh
# PARAM 1: recipe name
#   
#===============================================
check_any_installed()
{
  local recipe_name=$1
  local installed=$(find_all_installed $recipe_name)
  [ ".$installed" != "." ] && echo 1 || echo 0
}

#===============================================
#    NAME: find_all_installed
#    DESC: returns array of seed name and version
#          of all versions of a recipe installed.
#    NOTE: Expects that at least one version of 
#          recipe is installed. Use check_any_installed
#          prior to calling this function
# PARAM 1: recipe name
#   
#===============================================
find_all_installed()
{
  local recipe=$1
  local log_dir=$(log_dir_for $recipe)

  # now return array of seed names that are
  # installed for this recipe
  # This assumes that at least one seed in this
  # recipe has been installed. Best to use
  # check_any_installed before hand
  local installed_pattern="*.installed"
  if [ -d $log_dir ] 
  then
    local installed_seeds=`find $log_dir -name "$installed_pattern" | sort -r`
    for ins in $installed_seeds; do echo `basename $ins .installed`; done
  fi
}

#===============================================
#    NAME: log_dir_for
#    DESC: returns path for recipe's log dir
# PARAM 1: recipe name
#   
#===============================================
log_dir_for()
{
  local recipe_name=$1
  # TODO: See hack in bin/bb
  #
  # appends the recipe name
  # to the log directory if
  # that has not been done 
  # already. Hack to try to
  # avoid too much confusion with 
  # having the recipe name as part of the
  # log dir in most cases
  local log_dir=$LOG_DIR
  local log_base_name=`basename $log_dir`
  if [ "$log_base_name" != "$recipe" ]
  then
    log_dir="$LOG_DIR/$recipe"
  fi
  echo $log_dir
}

#===============================================
#    NAME: before_install
#    DESC: performs prerequiste functionality before
#          do_install is called.
#          Called by lib/case.sh
# PARAM 1: recipe name
#   
#===============================================
before_install()
{
  local recipe_name=$1
  mkdir -p $STAGE_DIR
  mkdir -p $LOCAL_DIR
  mkdir -p $TB_DIR
  mkdir -p $LOG_DIR
  mkdir -p $BIN_DIR
  mkdir -p $ETC_DIR
  mkdir -p $LIB_DIR
  mkdir -p $LIB64_DIR
  mkdir -p $LIBEXEC_DIR
  mkdir -p $MAN_DIR
  mkdir -p $INCLUDE_DIR
  mkdir -p $SHARE_DIR

  [ -f $LOG_DIR/$recipe_name.lock ] && usage 1 "Other instance is working on $recipe_name. Bailing out."
  touch $LOG_DIR/$recipe_name.lock
}

#===============================================
#    NAME: after_install
#    DESC: performs post functionality after
#          do_install is called.
#          Called by lib/case.sh
# PARAM 1: recipe name
#   
#===============================================
after_install()
{
  local recipe_name=$1
  log "chmod -R 755 $STAGE_DIR"
  chmod -R 755 $STAGE_DIR
  local lock_file="$LOG_DIR/$recipe_name.lock"
  local install_flag="$LOG_DIR/$recipe_name.installed"
  log "recipe [$recipe_name] installed."
  log "removing lock. [$lock_file]"
  rm -f $lock_file
  log "touching install flag [$install_flag]"
  touch $install_flag
}


