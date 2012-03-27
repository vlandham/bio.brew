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
#    NAME: switch_current
#    DESC: Moves current symlink. Used by link_from_stage
# PARAM 1: seed name
#===============================================
switch_current()
{
  local seed_name=$1; shift

  #first ensure the current link is present
  # and pointing to the current seed_name dir
  rm -f $STAGE_DIR/current
  ln -s $STAGE_DIR/$seed_name $STAGE_DIR/current
}

#===============================================
#    NAME: link_from_stage
#    DESC: Helper function to link install files
# PARAM 1: seed name
# PARAM 2: array of files to link
#===============================================
link_from_stage()
{
  local seed_name=$1; shift
  local install_files=("$@")

  switch_current $seed_name

  for f in ${install_files[@]} 
  do
    local bn=`basename $f`
    log "linking from staging area [$f]"
    rm -f $LOCAL_DIR/bin/$bn
    ln -s $STAGE_DIR/current/$f $LOCAL_DIR/bin/$bn
    log "Setting permission"
    [ -f $STAGE_DIR/$seed_name/$f ] && chmod 755 $STAGE_DIR/$seed_name/$f
  done
  return 0
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
