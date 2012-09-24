
local version="2.1.24"
local type="zip"
local tb_file="igvtools_nogenomes_${version}.${type}"
local URL="http://www.broadinstitute.org/igv/projects/downloads/${tb_file}"
local tb_dir="IGVTools"
local seed_name="igvtools_${version}"
local deps=(java)
local install_files=()

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
  switch_current $seed_name
  for_env "export IGVTOOLS='$STAGE_DIR/current'"
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
