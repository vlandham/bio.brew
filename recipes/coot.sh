
## DEPENDENCIES: mmdb, clipper

local version="0.7"
local type="tar.gz"
local URL="http://www.biop.ox.ac.uk/coot/software/source/releases/coot-$version.$type";
local tb_file=`basename $URL`
local seed_name="coot-${version}"
local install_files=()

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR
  cd $STAGE_DIR/$seed_name
  mkdir -p install
  configure_tool $seed_name "--prefix=$STAGE_DIR/$seed_name/install --with-mmdb-prefix=/n/local/stage/mmdb/current"
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
