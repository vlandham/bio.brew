
local version="1.4.14b"
local revision="stable"
local type="tar.gz"
local URL="http://monkey.org/~provos/libevent-${version}-${revision}.${type}"
local tb_file=`basename $URL`
local original_name=$(extract_tool_name $tb_file $type)
local seed_name="libevent-${version}"

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $original_name $STAGE_DIR/$seed_name
  cd $STAGE_DIR/$seed_name
  configure_tool $seed_name
  make_tool $seed_name
}

do_activate()
{
  cd $STAGE_DIR/$seed_name
  install_tool $seed_name
  link_library $seed_name
  # link_from_stage $seed_name ${install_files[@]}
}

do_remove()
{
  remove_recipe_using_make $seed_name
  #remove_from_stage $seed_name ${install_files[@]}
}

source "$MAIN_DIR/lib/case.sh"
