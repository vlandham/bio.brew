local URL="http://ftp.gnu.org/gnu/autoconf/autoconf-latest.tar.gz"
local tb_file=`basename $URL`
local type="tar.gz"
local seed_name="autoconf-2.68"
local install_files=(bin/autoupdate bin/autoscan bin/ifnames bin/autoreconf bin/autoheader bin/autoconf bin/autom4te)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  cd $seed_name
  configure_tool $seed_name
  make_tool $seed_name $make_j
  install_tool $seed_name
  link_from_stage $seed_name ${install_files[@]}
}

do_remove()
{
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
}

source "$MAIN_DIR/lib/case.sh"
