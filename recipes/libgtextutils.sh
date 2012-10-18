local version="0.6.1"
local lib_name="gtextutils"
local type="tar.bz2"
local URL="http://hannonlab.cshl.edu/fastx_toolkit/libgtextutils-${version}.${type}"
local tb_file=`basename $URL`
local seed_name="libgtextutils-${version}"

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR/$seed_name
  cd $STAGE_DIR/$seed_name
  configure_tool $seed_name
  make_tool $seed_name $make_j
  install_tool $seed_name
}

do_activate()
{
  link_library $seed_name
}

do_test()
{
  log "test"
}


do_remove()
{
  remove_recipe $seed_name
}

source "$MAIN_DIR/lib/case.sh"
