local version="2.10.9"
local type="tar.bz2"
local URL="http://download.mono-project.com/sources/mono/mono-${version}.${type}"
local tb_file=`basename $URL`
local seed_name="mono-${version}"
local install_files=(install/bin/mono)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR
  cd $STAGE_DIR/$seed_name

  mkdir -p install 
  configure_tool $seed_name "--with-large-heap=yes" "$STAGE_DIR/$seed_name/install" 
  make_tool $seed_name $make_j  
  install_tool $seed_name 
}

do_activate()
{
  link_from_stage $seed_name ${install_files[@]}
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
