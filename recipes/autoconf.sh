local version="2.68"
local type="tar.gz"
local URL="http://ftp.gnu.org/gnu/autoconf/autoconf-${version}.${type}"
local tb_file=`basename $URL`
local seed_name="autoconf-${version}"
local install_files=(bin/autoupdate bin/autoscan bin/ifnames bin/autoreconf bin/autoheader bin/autoconf bin/autom4te)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  cd $seed_name
  configure_tool $seed_name
  make_tool $seed_name $make_j
  cd ..
  mv $seed_name $STAGE_DIR
}

do_activate()
{
  cd $STAGE_DIR
  cd $seed_name
  install_tool $seed_name
  link_from_stage $seed_name ${install_files[@]}
}

do_remove()
{
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
}

source "$MAIN_DIR/lib/case.sh"
