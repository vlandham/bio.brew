
local version="20121222"
local type="tar.bz2"
local URL="http://ftp.gnu.org/gnu/parallel/parallel-${version}.${type}"

local tb_file=`basename $URL`
local seed_name="parallel-${version}"
# local install_files=(libg2.a g2.h g2_X11.h g2_gd.h g2_PS.h)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR
  cd $STAGE_DIR/$seed_name

  # export CFLAGS="$CFLAGS -I/usr/lib64"
  # export CXXFLAGS="$CXXFLAGS -I/usr/lib64"
  # export LDFLAGS="-L/usr/lib64 $LDFLAGS"
  # export LD_LIBRARY_PATH="/usr/lib64:$LD_LIBRARY_PATH"
  # export LIBS="-l/usr/lib64 $LIBS"

  mkdir $STAGE_DIR/$seed_name/install
  configure_tool $seed_name "" "$STAGE_DIR/$seed_name/install"

  make_tool $seed_name $make_j 

  # this will install the files in $STAGE_DIR/$seed_name/install .
  #  in do_activate(), we will symlink these files out
  install_tool $seed_name
}

do_activate()
{
  # link_from_stage $seed_name ${install_files[@]}
  switch_current $seed_name
  link_bin $seed_name 'install/bin'
  link_share $seed_name 'install/share'
}

do_test()
{
  log "test"
}


do_remove()
{
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
}

source "$MAIN_DIR/lib/case.sh"
