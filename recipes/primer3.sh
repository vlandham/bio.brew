local version="2.3.4"
local type="tar.gz"
local URL="http://downloads.sourceforge.net/project/primer3/primer3/${version}/primer3-${version}.${type}"
local tb_file=`basename $URL`
local seed_name="primer3-${version}"
local install_files=(src/primer3_core)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  cd $seed_name/src
  make_tool $seed_name $make_j
  cd ../..
  mv $seed_name $STAGE_DIR
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
