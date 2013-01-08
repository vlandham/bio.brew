
### IN PROGRESS - APA

local version="0.72"
local type="tar.gz"
local URL="http://sourceforge.net/projects/g2/files/g2/g2-$version/g2-$version.tar.gz";

local tb_file=`basename $URL`
local seed_name="g2-${version}"
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
  export CFLAGS="-fPIC"
  configure_tool $seed_name "" "$STAGE_DIR/$seed_name/install"

  # as these recipes are just regular shell scripts, we can execute 
  # the commands just like we would from the command line
  make depend
  make_tool $seed_name $make_j 

  # this will install the files in $STAGE_DIR/$seed_name/install .
  #  in do_activate(), we will symlink these files out
  install_tool $seed_name

  ## Perl support
  cd $STAGE_DIR/$seed_name/g2_perl
  perl Makefile.PL
  make
  # make test
}

do_activate()
{
  # link_from_stage $seed_name ${install_files[@]}
  link_library $seed_name 'install/lib'
  link_include $seed_name 'install/include'
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
