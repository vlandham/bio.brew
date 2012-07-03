
local version="3.3a"
local type="tar.gz"
local URL="http://cbio.mskcc.org/microrna_data/miRanda-aug2010.tar.gz"
local tb_file=`basename $URL`
local extract_name="miRanda-${version}"
local seed_name="miranda_$version"
local tb_dir="miranda"
local install_files=(src/miranda)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $extract_name $STAGE_DIR/$seed_name
  cd $STAGE_DIR/$seed_name
  configure_tool $seed_name
  make_tool $seed_name
}

do_activate()
{
  link_from_stage $seed_name ${install_files[@]}
}

do_test()
{
  log "test"
}

do_remove()
{
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
}

source "$MAIN_DIR/lib/case.sh"
