local version="3.8.31"
local type="tar.gz"
local URL="http://www.drive5.com/muscle/downloads$version/muscle${version}_i86linux64.tar.gz"
local tb_file=`basename $URL`
local seed_name=$(extract_tool_name $tb_file $type)
echo $seed_name
local install_files=()

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mkdir -p $STAGE_DIR/$seed_name
  mv $seed_name $STAGE_DIR/$seed_name
}

do_activate()
{
  switch_current $seed_name
  ln -s $STAGE_DIR/current/$seed_name $BIN_DIR/muscle
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
