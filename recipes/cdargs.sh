
local version="1.35"
local type="tar.gz"
local URL="http://www.skamphausen.de/downloads/cdargs/cdargs-${version}.${type}"
local tb_file=`basename $URL`
local seed_name="cdargs-${version}"
local install_files=(bin/cdargs contrib/cdargs-bash.sh)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR
  cd $STAGE_DIR/$seed_name
  configure_tool $seed_name
  make_tool $seed_name
  install_tool $seed_name
  link_from_stage $seed_name ${install_files[@]}
}

do_activate()
{
  link_from_stage $seed_name ${install_files[@]}
}

do_remove()
{
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
  rm -f $LOCAL_DIR/bin/cdargs-bash.sh
}

source "$MAIN_DIR/lib/case.sh"
