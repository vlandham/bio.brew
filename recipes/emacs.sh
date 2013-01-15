
local version="24.2"
local type="tar.gz"
local URL="http://ftp.gnu.org/pub/gnu/emacs/emacs-$version.$type";

local tb_file=`basename $URL`
local seed_name="emacs-${version}"
# local install_files=(libg2.a g2.h g2_X11.h g2_gd.h g2_PS.h)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR
  cd $STAGE_DIR/$seed_name

  # using special invocation of the configure_tool to put
  # installed files into a sub-directory called 'install'
  # not always needed/preferred way to install packages - but it works
  #configure_tool $seed_name "CFLAGS=\"-g -I/usr/local/include -fPIC\" CXXFLAGS=\"-fPIC\"" "$STAGE_DIR/$seed_name/install"
  # export CFLAGS="$CFLAGS -I/usr/lib64"
  # export CXXFLAGS="$CXXFLAGS -I/usr/lib64"
  export LDFLAGS="-L/usr/lib64 $LDFLAGS"
  export LD_LIBRARY_PATH="/usr/lib64:$LD_LIBRARY_PATH"
  # export LIBS="-l/usr/lib64 $LIBS"

  mkdir $STAGE_DIR/$seed_name/install
  configure_tool $seed_name "--with-xpm  --with-jpeg  --with-tiff  --with-gif  --with-png" "$STAGE_DIR/$seed_name/install"

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
  link_libexec $seed_name 'install/libexec'
  link_share $seed_name 'install/share'
  link_var $seed_name 'install/var'
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
