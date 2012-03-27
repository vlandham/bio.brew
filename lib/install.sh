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
#    NAME: configure_tool
#    DESC: Runs a tool's ./configure script.
#          If no prefix is given, defaults
#          To seed's stage dir
# PARAM 1: seed name
# PARAM 2: options to be passed to configure 
# PARAM 3: prefix to use for configure --prefix
#   
#===============================================
configure_tool()
{
  local seed_name=$1
  local options=$2
  local prefix=$3
  local log_file="$LOG_DIR/${seed_name}.configure.log.txt"

  [ ".$prefix" ==  "." ] && prefix=$STAGE_DIR/$seed_name
  log "running configure [logging output: $log_file]"
  ./configure --prefix=$prefix $options &> $log_file
}

#===============================================
#    NAME: make_tool
#    DESC: Runs a tool's make script.
#    NOTE: Exports a number of paths to
#          attempt to ensure that the tool is 
#          built and contained in the seed dir
# PARAM 1: seed name
# PARAM 2: make -j number to use
#   
#===============================================
make_tool()
{
  local seed_name=$1
  local make_j=$2
  [ ".$make_j" == "." ] && make_j=1
  local log_file=$LOG_DIR/${seed_name}.make.log.txt
  log "running make on tool [logging output: $log_file] [j: $make_j]"
  (
  export LIBRARY_PATH=$LIB_DIR
  export CPATH=$INCLUDE_DIR
  make -j $make_j &> $log_file
  )
}

#===============================================
#    NAME: install_tool
#    DESC: Runs a tool's make install script.
#   
#===============================================
install_tool()
{
  local log_file=$LOG_DIR/${seed_name}.install.log.txt
  log "installing tool [logging output: $log_file]"
  make install &> $log_file
}

#===============================================
#    NAME: download
#    DESC: Helper function for downloading a
#          a url with curl
# PARAM 1: url of file to download
# PARAM 2: location to download it to
#   
#===============================================
download()
{
  local url=$1
  local tb_file=$2
  if [ -f $TB_DIR/$tb_file ]
  then
    log "$tb_file already downloaded, skipping"
  else
    log "downloading [$url]"
    curl --silent -L -O $url
  fi 
}

#===============================================
#    NAME: download_git
#    DESC: Helper function for downloading a
#          a url with git clone
# PARAM 1: url of file to download
# PARAM 2: location to download it to
#   
#===============================================
download_git()
{
  local url=$1
	local download_file=$2
	local log_file=$LOG_DIR/${download_file}.git.log.txt
  log "git cloning: $url to $download_file"
  git clone $url $download_file &> $log_file
}

#===============================================
#    NAME: decompress_tool
#    DESC: Helper function un-compressing a number
#          of different archive formats. Currently
#          can handle: tar.gz, tar.bz2, tgz, zip
# PARAM 1: archive file to decompress
# PARAM 2: file type of archive file
#   
#===============================================
decompress_tool()
{
  local tb_file=$1
  local tb_type=$2
  log "decompressing package: $tb_file ($tb_type)"
  case $tb_type in
    "tar.gz")
      tar zxf $tb_file
    ;;
    "tar.bz2")
      tar jxf $tb_file
    ;;
    "tgz")
      tar zxf $tb_file
    ;;
    "zip")
      unzip $tb_file
    ;;
    ?)
      log "Problems decompressing $tb_file" 1
    ;;
  esac
}

#===============================================
#    NAME: clear_env
#    DESC: removes recipe's env file. The env file
#          is sourced by bb_load_env to provide
#          recipe specific environment vars
#  GLOBAL: $recipe. Set in bb_install
#   
#===============================================
clear_env()
{
  rm -f $LOG_DIR/$recipe.env.sh
}

#===============================================
#    NAME: for_env
#    DESC: adds content to env file. The env file
#          is sourced by bb_load_env to provide
#          recipe specific environment vars
# PARAM 1: content to put into recipes env file
#  GLOBAL: $recipe. Set in bb_install
#   
#===============================================
for_env()
{
  echo $1 >> $LOG_DIR/$recipe.env.sh
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
    if [ $(check_if_external_installed $f) == "1" ]
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
#          Currently uses rpm to try to find packages.
# PARAM 1: package name
#   
#===============================================
check_if_external_installed()
{
  local package_name=$1
  rtn=1

  local apt_get=`which apt-get 2> /dev/null`
  #if [ ".$apt_get" != "." ]
  #then
    # assume ubuntu / debian box
  #fi

  local rpm=`which rpm 2> /dev/null`
  if [ ".$rpm" != "." ]
  then
    # assume redhat / centOS box
    local package_found=`rpm -qi $package_name 2> /dev/null`
    [[ $package_found != *not*installed* ]] && rtn=0 || rtn=1
  fi

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
    local installed_seeds=`find $log_dir -name "$installed_pattern"`
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
  mkdir -p $MAN_DIR

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
  local lock_file="$LOG_DIR/$recipe_name.lock"
  local install_flag="$LOG_DIR/$recipe_name.installed"
  log "recipe [$recipe_name] installed."
  log "removing lock. [$lock_file]"
  rm -f $lock_file
  log "touching install flag [$install_flag]"
  touch $install_flag
}

#===============================================
#   WARNING: Untested perl helpers below
#===============================================

cpan_remove()
{
  local p_module=$1
  local log_file=$LOG_DIR/${seed_name}.cpan.uninstall.log.txt
  log "Removing CPAN module: ${p_module}"
  (echo "u $p_module") | cpan &> $log_file
}

cpan_install()
{
  local p_module=$1
  local log_file=$LOG_DIR/${seed_name}.cpan.install.log.txt
  log "Installing CPAN module: ${p_module}"
  (echo "force install $p_module") | cpan &> $log_file
}

setup_cpan_policy()
{
  log "Setting up CPAN policy to follow."
  local log_file=$LOG_DIR/cpan.policy.log.txt
  (echo y; echo o conf prerequisites_policy follow;echo o conf commit) | cpan &> $log_file
}

setup_cpan_config()
{
  cp_dir="$HOME/.cpan/CPAN"
  cp_config="$cp_dir/MyConfig.pm"

  setup_cpan_policy
  if [ -f $cp_config ] 
  then
    log "Cannot setup CPAN config. Already exists"  
  else
    log "Setting up CPAN config."
    mkdir -p $cp_dir
    ( 
    cat<<-EOF
\$CPAN::Config = {
  'auto_commit' => q[0],
  'build_cache' => q[100],
  'build_dir' => q[${HOME}/.cpan/build],
  'cache_metadata' => q[1],
  'commandnumber_in_prompt' => q[1],
  'connect_to_internet_ok' => q[1],
  'cpan_home' => q[${HOME}/.cpan],
  'ftp_passive' => q[1],
  'ftp_proxy' => q[],
  'http_proxy' => q[],
  'inactivity_timeout' => q[0],
  'index_expire' => q[1],
  'inhibit_startup_message' => q[0],
  'keep_source_where' => q[${HOME}/.cpan/sources],
  'load_module_verbosity' => undef,
  'make_arg' => q[],
  'make_install_arg' => q[],
  'make_install_make_command' => q[],
  'makepl_arg' => q[],
  'mbuild_arg' => q[],
  'mbuild_install_arg' => q[],
  'mbuild_install_build_command' => q[./Build],
  'mbuildpl_arg' => q[],
  'no_proxy' => q[],
  'prerequisites_policy' => q[follow],
  'scan_cache' => q[atstart],
  'show_upload_date' => q[0],
  'term_ornaments' => q[1],
  'urllist' => [q[ftp://cpan.pair.com/pub/CPAN/], q[ftp://cpan.netnitco.net/pub/mirrors/CPAN/], q[ftp://cpan.mirrors.tds.net/pub/CPAN], q[ftp://cpan.llarian.net/pub/CPAN/]],
  'use_sqlite' => q[0],
};
1;
__END__
EOF
    ) > $cp_config
  fi
}
