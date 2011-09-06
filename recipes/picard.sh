
local version="1.52"
local type="zip"
local tb_file="picard-tools-${version}.${type}"
local URL="http://sourceforge.net/projects/picard/files/picard-tools/${version}/${tb_file}"
local tb_dir=`basename $tb_file .$type`
local seed_name="picard_${version}"
local deps=(java)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $tb_dir $seed_name
  mv $seed_name $STAGE_DIR
}

do_activate()
{
  ln -s $STAGE_DIR/$seed_name $STAGE_DIR/current
  for_env "export PICARD='$STAGE_DIR/current'"
}

do_remove()
{
  remove_recipe $seed_name
}

source "$MAIN_DIR/lib/case.sh"
