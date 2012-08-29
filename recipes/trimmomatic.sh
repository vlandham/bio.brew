
local version="0.22"
local type="zip"
local tb_file="Trimmomatic-${version}.${type}"
local URL="http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/${tb_file}"
local tb_dir=`basename $tb_file .$type`
local seed_name="trimmomatic_${version}"
local deps=(java)
local install_files=(${seed_name}.jar)

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
  link_from_stage $seed_name ${install_files[@]}
}

do_test()
{
	log "test"
}

do_remove()
{
  remove_recipe $seed_name
}

source "$MAIN_DIR/lib/case.sh"
