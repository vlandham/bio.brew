local version="2.1"
local type="tar.gz"
local URL="http://www.tbi.univie.ac.at/~wash/RNAz/RNAz-$version.$type"
local tb_file=`basename $URL`
local seed_name="RNAz-${version}"
local install_files=(bin/RNAz)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR
  cd $STAGE_DIR/$seed_name
  mkdir -p install
  configure_tool $seed_name "$STAGE_DIR/$seed_name/install"
  make_tool $seed_name $make_j 
  install_tool $seed_name
}

do_activate()
{
  switch_current $seed_name
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
