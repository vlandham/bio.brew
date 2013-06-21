## THIS IS FOR "REAPR", THE NCRNA-PREDICTION PACKAGE FROM MIT

## DEPENDENCIES: Python >= 2.7.2; ViennaRNA >= 2.0.5; RNAz >= 2.0; LocARNA >= 1.7.1

local version="1.0"
local type="zip"
local URL="http://groups.csail.mit.edu/cb/reapr/Software/reapr.$type"
local tb_file=`basename $URL`
local seed_name="reapr-$version"
local install_files=()

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
#  decompress_tool $tb_file $type
#  mv $seed_name $STAGE_DIR
}

do_activate()
{
  link_from_stage $seed_name ${install_files[@]}
  switch_current $seed_name
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
