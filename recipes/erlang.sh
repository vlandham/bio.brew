local version="R15B01"
local type="tar.gz"
local tb_name="otp_src_${version}"
local URL="http://erlang.org/download/${tb_name}.${type}"
local tb_file=`basename $URL`
local seed_name="erlang-${version}"
local install_files=()

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $tb_name $STAGE_DIR/$seed_name
  cd $STAGE_DIR/$seed_name
  configure_tool $seed_name
  make_tool $seed_name $make_j
}

do_activate()
{
  link_from_stage $seed_name ${install_files[@]}
  for_env "export PATH=\"$STAGE_DIR/current/bin:\$PATH\""
  for_env "export LD_LIBRARY_PATH=\"$STAGE_DIR/current/lib:\$LD_LIBRARY_PATH\""
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
