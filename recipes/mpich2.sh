local version="1.4.1p1"
local type="tar.gz"
local URL="http://www.mcs.anl.gov/research/projects/mpich2/downloads/tarballs/${version}/mpich2-${version}.${type}"
local tb_file=`basename $URL`
local seed_name="mpich2-${version}"

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR
  cd $STAGE_DIR/$seed_name
  configure_tool $seed_name "" "$STAGE_DIR/$seed_name/install"
  make_tool $seed_name $make_j
  install_tool $seed_name
}

do_activate()
{
  switch_current $seed_name
  ln -s $STAGE_DIR/current/install/bin $BIN_DIR/mpich2
  for_env "export PATH=\"$BIN_DIR/mpich2:\$PATH\""
  link_include $seed_name 'install/include'
  link_library $seed_name 'install/lib'
  link_files $seed_name 'install/sbin' 'sbin'
}

do_test()
{
  log "test"
}


do_remove()
{
  rm -f $BIN_DIR/mpich2
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
}

source "$MAIN_DIR/lib/case.sh"
