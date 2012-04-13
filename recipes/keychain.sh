local version="2.7.1"
local type="tar.bz2"
local URL="http://www.funtoo.org/archive/keychain/keychain-${version}.${type}"
local tb_file=`basename $URL`
local seed_name="keychain-${version}"
local install_files=(keychain)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR
}

do_activate()
{
  link_from_stage $seed_name ${install_files[@]}
}

do_remove()
{
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
}

source "$MAIN_DIR/lib/case.sh"
