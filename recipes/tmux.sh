
local version="1.6"
local type="tar.gz"
local URL="http://softlayer.dl.sourceforge.net/project/tmux/tmux/tmux-${version}/tmux-${version}.${type}"
local tb_file=`basename $URL`
local seed_name="tmux-${version}"
local install_files=(tmux)
local deps=("libevent")

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR
  cd $STAGE_DIR/$seed_name
  configure_tool $seed_name
  make_tool $seed_name
}

do_activate()
{
  log "NOTE: make sure to setup LD_LIBRARY_PATH to point to the bb dist/lib"
  log "done automatically with bb_load_env"
  for_env "export LD_LIBRARY_PATH='$LIB_DIR':$LD_LIBRARY_PATH"
  link_from_stage $seed_name ${install_files[@]}
}

do_remove()
{
  remove_recipe $seed_name
  remove_from_stage $seed_name tmux
}

source "$MAIN_DIR/lib/case.sh"
