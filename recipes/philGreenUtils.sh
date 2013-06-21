local version="0.0.1" 
local type="tar.gz"
  
local URL=""
local tb_file="/n/local/bin/bio.brew/resources/philGreenUtils/distrib.${type}"
local original_name="philGreenUtils"
local seed_name="philGreenUtils-${version}"
local install_files=(phred phrap calf_merge cluster cross_match loco phrap_view swat)

do_install()
{
  mkdir -p $STAGE_DIR/$seed_name
  cp $tb_file $STAGE_DIR/$seed_name
  cd $STAGE_DIR/$seed_name
  decompress_tool distrib.tar.gz $type
  cd $STAGE_DIR/$seed_name
  make_tool $seed_name $make_j
  # install_tool $seed_name
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
