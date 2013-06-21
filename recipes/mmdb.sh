local version_major="1.23"
local version_minor="2.2"
local version=$version_major.$version_minor;
local type="tar.gz"
local URL="https://launchpad.net/mmdb/$version_major/$version/+download/mmdb-$version.$type";
local tb_file=`basename $URL`
local seed_name="mmdb-${version}"
local install_files=()

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR
  cd $STAGE_DIR/$seed_name
  configure_tool $seed_name "CONFIG_SHELL=/bin/bash PREFIX=$STAGE_DIR/$seed_name"
  make_tool $seed_name $make_j 
  install_tool $seed_name
}

do_activate()
{
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
