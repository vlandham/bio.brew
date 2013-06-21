local version="2.0.2"
local type="tar.gz"
#https://sparsehash.googlecode.com/files/sparsehash-2.0.2.tar.gz
local URL="https://sparsehash.googlecode.com/files/sparsehash-${version}.${type}"
local tb_file="sparsehash-${version}.${type}";
local seed_name="sparsehash-${version}"

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR

  cd $STAGE_DIR/$seed_name
  mkdir $STAGE_DIR/$seed_name/install
  configure_tool $seed_name "" "$STAGE_DIR/$seed_name/install"

  make_tool $seed_name $make_j
  install_tool $seed_name
}

do_activate()
{
  switch_current $seed_name
  link_include $seed_name 'install/include'
  link_library $seed_name 'install/lib'
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
