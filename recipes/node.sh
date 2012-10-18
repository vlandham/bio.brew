# now uses pre-compiled binaries, to get things working
local version="0.8.12"
local type="tar.gz"
local URL="http://nodejs.org/dist/v${version}/node-v${version}-linux-x64.${type}"
# local URL="http://nodejs.org/dist/v${version}/node-v${version}.${type}"
local tb_file=`basename $URL`
local tb_directory=`basename $URL .${type}`
local seed_name="node-${version}"
local install_files=(bin/node bin/node-waf bin/npm)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $tb_directory $STAGE_DIR/$seed_name
  cd $STAGE_DIR/$seed_name
  # make_tool $seed_name $make_j
  # cd ..
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
