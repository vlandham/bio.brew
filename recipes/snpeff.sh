
local version="2_0_4_rc1"
local type="zip"
local tb_file="snpEff_v${version}.${type}"
local URL="http://sourceforge.net/projects/snpeff/files/${tb_file}"
local tb_dir=`basename $tb_file .$type`
local seed_name="snpeff_${version}"
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
  for_env "export SNPEFF='$STAGE_DIR/current'"
}

do_remove()
{
  remove_recipe $seed_name
}

source "$MAIN_DIR/lib/case.sh"
