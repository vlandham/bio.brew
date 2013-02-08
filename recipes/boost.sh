local version="1.51.0"
local version2=${version//\./_}
local type="tar.gz"
local URL="http://sourceforge.net/projects/boost/files/boost/$version/boost_$version2.tar.gz"
local tb_file=`basename $URL`
local seed_name=$(extract_tool_name $tb_file $type)
local install_files=()

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR/$seed_name
}

do_activate()
{
  switch_current $seed_name
  ln -s $STAGE_DIR/current $BIN_DIR/boost
}

do_remove()
{
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
}

do_test()
{
  log "test"
}

source "$MAIN_DIR/lib/case.sh"
