local version="1.8.2"
local type="tar.gz"
local URL="http://mirrors.kahuki.com/apache//ant/binaries/apache-ant-${version}-bin.${type}"
local tb_file=`basename $URL`
local seed_name="apache-ant-${version}"
local deps=(java)
local root_seed="apache-ant-${version}"

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR
}

do_activate()
{
  clear_env
  for_env " export PATH=\"$STAGE_DIR/$seed_name/bin:\$PATH\" "
  for_env " export ANT_HOME='$STAGE_DIR/$seed_name'"
}

do_test()
{
  log "test"
}

do_remove()
{
  rm -rf $STAGE_DIR/$seed_name*
}

source "$MAIN_DIR/lib/case.sh"
