local version="0.0.1"
local type="tar.gz"
# sourceforge mirror was found by copying download link in 
# Firefox's download manager.
local URL="http://bioinfo.wilmer.jhu.edu/~hujf/Stowers/Sources.tar.gz"
local tb_file=`basename $URL`
local seed_name="mopat-${version}"
local install_files=(mopat mopato)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv Sources $seed_name
  mv $seed_name $STAGE_DIR
  cd $STAGE_DIR/$seed_name
  g++ mopat.cpp -o mopat
  g++ mopato.cpp -o mopato
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
