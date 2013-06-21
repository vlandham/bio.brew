local version="3.23"
local type="tar.gz"
# sourceforge mirror was found by copying download link in 
# Firefox's download manager.
local URL="http://sourceforge.net/projects/mummer/files/mummer/$version/MUMmer$version.$type/download"
local tb_file=`basename $URL`
local seed_name="MUMmer$version"
local install_files=(mummer nucmer promer run-mummer1 run-mummer3)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  cd $seed_name
  make_tool $seed_name $make_j
  cd ..
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
