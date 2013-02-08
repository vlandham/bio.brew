
### IN PROGRESS - APA

local version="4.8.1"
local release="2727"
local version2=${version//\./_}
local type="tar.gz"
local URL="http://downloads.sourceforge.net/project/mev-tm4/mev-tm4/MeV%20$version/MeV_${version2}_r${release}_linux.$type"
local tb_file=`basename $URL`
local seed_name=$(extract_tool_name $tb_file $type)
echo $seed_name
local install_files=()

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mkdir -p $STAGE_DIR/$seed_name
  mv $seed_name $STAGE_DIR/$seed_name
}

do_activate()
{
  switch_current $seed_name
}

do_remove()
{
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
}

do_test()
{
  log "test"
}

source "$MAIN_DIR/lib/case.sh"
