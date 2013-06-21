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
  export LIBRARY_PATH=$LIB_DIR:$LIBRARY_PATH
  export CPATH=$INCLUDE_DIR:$CPATH

  [ ".$prefix" ==  "." ] && prefix=$STAGE_DIR/$seed_name
  log "running configure [logging output: $log_file]"
  log "prefix: $prefix"
  log "options: $options"
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
  export LIBRARY_PATH=$LIB_DIR:$LIBRARY_PATH
  export CPATH=$INCLUDE_DIR:$CPATH
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
    "tar")
      tar xf $tb_file
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
    rm -f $BIN_DIR/$bn
    ln -s $STAGE_DIR/current/$f $BIN_DIR/$bn
    log "Setting permission"
    [ -f $STAGE_DIR/$seed_name/$f ] && chmod 755 $STAGE_DIR/$seed_name/$f
  done
  return 0
}

#===============================================
#    NAME: link_include
#    DESC: Helper function to link include files
# PARAM 1: seed name
#===============================================
link_bin()
{
  local seed_name=$1
  local bin_dir=$2
  [ ".$bin_dir" ==  "." ] && bin_dir='bin'
  link_files $seed_name $bin_dir 'bin'
}

#===============================================
#    NAME: link_library
#    DESC: Helper function to link library files
# PARAM 1: seed name
#===============================================
link_library()
{
  local seed_name=$1
  local lib_dir=$2
  [ ".$lib_dir" ==  "." ] && lib_dir='lib'
  link_files $seed_name $lib_dir 'lib'
}

#===============================================
#    NAME: link_include
#    DESC: Helper function to link include files
# PARAM 1: seed name
#===============================================
link_include()
{
  local seed_name=$1
  local include_dir=$2
  [ ".$include_dir" ==  "." ] && include_dir='include'
  link_files $seed_name $include_dir 'include'
}

#===============================================
#    NAME: link_share
#    DESC: Helper function to link share files
# PARAM 1: seed name
#===============================================
link_share()
{
  local seed_name=$1
  local share_dir=$2
  [ ".$share_dir" ==  "." ] && share_dir='share'
  link_files $seed_name $share_dir 'share'
}

#===============================================
#    NAME: link_share
#    DESC: Helper function to link man files
# PARAM 1: seed name
#===============================================
link_man()
{
  local seed_name=$1
  local man_dir=$2
  [ ".$man_dir" ==  "." ] && man_dir='man'
  link_files $seed_name $man_dir 'man'
}

#===============================================
#    NAME: link_libexec
#    DESC: Helper function to link libexec files
# PARAM 1: seed name
#===============================================
link_libexec()
{
  local seed_name=$1
  local libexec_dir=$2
  [ ".$libexec_dir" ==  "." ] && libexec_dir='libexec'
  link_files $seed_name $libexec_dir 'libexec'
}

#===============================================
#    NAME: link_libexec
#    DESC: Helper function to link libexec files
# PARAM 1: seed name
#===============================================
link_var()
{
  local seed_name=$1
  local var=$2
  [ ".$var" ==  "." ] && var='var'
  link_files $seed_name $var 'var'
}

#===============================================
#    NAME: link_files
#    DESC: Helper function to link files in a 
#          given directory.
# PARAM 1: seed name
# PARAM 2: dir_from - directory to link files from.
# PARAM 3: dir_to  - directory to link files to.
#          Defaults to dir_from.
#===============================================
link_files()
{
  local seed_name=$1
  local dir_name=$2
  local dir_to_name=$3
  [ ".$dir_to_name" ==  "." ] && dir_to_name=$dir_name

  # first unlink all current files related to this
  #  seed_name
  unlink_files $seed_name $dir_name

  # old_root is the full path to the root directory of
  #  dir_name inside of the seed's stage directory.
  local old_root="$STAGE_DIR/$seed_name/${dir_name}"

  # new_root is where the files will be simlinked to
  local new_root="$LOCAL_DIR/${dir_to_name}"

  switch_current $seed_name

  # loop through all files in old_root
  for f in `find $old_root -type f`
  do

    # regex replacement. replaces old_root with new_root
    local new_file_path=${f//$old_root/$new_root}
    log "linking $f to $new_file_path"

    # make directory if necessary
    mkdir -p `dirname ${new_file_path}`
    ln -f -s $f $new_file_path
  done
  return 0
}

#===============================================
#    NAME: unlink_files
#    DESC: Helper function to unlink files
#          found linked from a seed directory
# PARAM 1: seed name
# PARAM 2: dir to look for to find files sym linked
#           from seed_name's stage dir
#===============================================
unlink_files()
{
  local seed_name=$1
  local dir_name=$2
  log "unlinking files from $seed_name in $dir_name"

  # full_active_dir is the directory we are
  #  searching in to find files to remove
  local full_active_dir="$LOCAL_DIR/${dir_name}"

  # full_search_dir is the directory that we
  #  are searching for sym links into. If
  #  a sym link inside full_active_dir includes
  #  full_search_dir in its path, it will be
  #  removed.
  local full_search_dir="$STAGE_DIR/$seed_name"

  for f in `find -P $full_active_dir`
  do
    # readlink gives symlink path for a file
    # ref: http://stackoverflow.com/questions/130329/how-do-you-get-what-a-symbolic-link-points-to-without-grep
    local sym_link_path=`readlink $f`

    # alternative to using regex inside bash.
    # could be done another way
    # ref: http://www.unix.com/unix-dummies-questions-answers/43073-regex-if-then-else-statement-match-strings.html
    if echo $sym_link_path | grep "$full_search_dir"
    then
      log "removing $f from $dir_name"
      rm $f
    fi
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
