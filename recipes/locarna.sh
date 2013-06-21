local version="1.7.6"
local type="tar.gz"
local URL="http://www.bioinf.uni-freiburg.de/Software/LocARNA/Releases/locarna-$version.$type"
local tb_file=`basename $URL`
local seed_name="locarna-${version}"
local install_files=(install/bin/dot2pp install/bin/locarna install/bin/locarna_deviation install/bin/locarna-mea install/bin/locarna-motif-scan install/bin/locarna_p install/bin/locarnap_fit install/bin/locarna_rnafold_pp install/bin/locarnate install/bin/mlocarna install/bin/mlocarna_nnames install/bin/plot-bmprobs install/bin/pp2dot install/bin/ribosum2cc)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR
  cd $STAGE_DIR/$seed_name
  mkdir -p install
  configure_tool $seed_name "--enable-librna --with-vrna=/n/local/stage/viennaRNA/current/install --prefix=$STAGE_DIR/$seed_name/install"
  make_tool $seed_name $make_j 
  install_tool $seed_name
}

do_activate()
{
  link_from_stage $seed_name ${install_files[@]}
  switch_current $seed_name
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
