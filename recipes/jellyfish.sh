local version="1.1.10"
local type="tar.gz"
local URL="http://www.cbcb.umd.edu/software/jellyfish/jellyfish-${version}.$type"
local tb_file=`basename $URL`
local seed_name="jellyfish-${version}"
local install_files=(bin/jellyfish)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR
  cd $STAGE_DIR/$seed_name
  configure_tool $seed_name "--prefix=$STAGE_DIR/$seed_name"
  make_tool $seed_name $make_j
  install_tool $seed_name
}

do_activate()
{
  switch_current $seed_name
  link_library $seed_name 'install/lib'
  for_env "export PKG_CONFIG_PATH=\"$STAGE_DIR/$seed_name/install/lib/pkgconfig:\$PKG_CONFIG_PATH\""
  link_from_stage $seed_name ${install_files[@]}
}

do_test()
{
  cd $STAGE_DIR/$seed_name
  make check BIG=1
  log "check"
}

do_remove()
{
  remove_recipe $seed_name
}

source "$MAIN_DIR/lib/case.sh"
