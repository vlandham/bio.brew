local version="1.3.5"
local type="tar.gz"
# sourceforge mirror was found by copying download link in 
# Firefox's download manager.

# warning - This link has changed a few times now...
# http://www.bcgsc.ca/platform/bioinfo/software/abyss/releases/1.3.5/abyss-1.3.5.tar.gz
local URL="http://www.bcgsc.ca/platform/bioinfo/software/abyss/releases/${version}/abyss-${version}.${type}"
local tb_file="abyss-${version}.${type}";
local seed_name="abyss-${version}"
local deps=(sparsehash)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR

  cd $STAGE_DIR/$seed_name
  mkdir $STAGE_DIR/$seed_name/install
  configure_tool $seed_name "CPPFLAGS=-I/n/local/include" "$STAGE_DIR/$seed_name/install"
 
  make_tool $seed_name $make_j
  install_tool $seed_name
}

do_activate()
{
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
