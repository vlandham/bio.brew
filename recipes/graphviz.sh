local version="2.28.0"
local type="rpm"
local URL="http://www.graphviz.org/pub/graphviz/stable/redhat/el6/x86_64/os/graphviz-$version-1.el6.x86_64.rpm"
local tb_file=`basename $URL`
local extract_name="graphviz-${version}"
local seed_name="graphviz-${version}"
local install_files=()

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
