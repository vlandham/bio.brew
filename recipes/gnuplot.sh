local version="4.4.4"
local type="tar.gz"
local URL="http://sourceforge.net/projects/gnuplot/files/gnuplot/${version}/gnuplot-${version}.${type}"
local tb_file=`basename $URL`
local seed_name="gnuplot-${version}"
local install_files=(bin/gnuplot)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  cd $seed_name
  configure_tool $seed_name
  make_tool $seed_name $make_j
  install_tool $seed_name
  rm -rf $TB_DIR/$seed_name
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
