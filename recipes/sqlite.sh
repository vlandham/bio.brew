
local version="3071300"
local type="tar.gz"
local URL="http://sqlite.org/sqlite-autoconf-${version}.${type}"
local tb_file=`basename $URL .$type`
local seed_name="sqlite-${version}"
local deps=()
local install_files=(bin/sqlite3)

do_install()
{
  cd $TB_DIR
  download $URL $seed_name
  decompress_tool $tb_file.$type $type
  mv $tb_file $STAGE_DIR/$seed_name
  cd $STAGE_DIR/$seed_name
  configure_tool $seed_name
  make_tool $seed_name
  make install
}

do_activate()
{
  link_from_stage $seed_name ${install_files[@]}
  link_library $seed_name
  link_include $seed_name
}

do_test()
{
  cd $STAGE_DIR
}

do_remove()
{
  remove_recipe $seed_name
}

source "$MAIN_DIR/lib/case.sh"
