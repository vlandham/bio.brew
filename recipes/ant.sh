
local version="1.8.1"
local URL="http://mirrors.kahuki.com/apache//ant/binaries/apache-ant-${version}-bin.tar.gz"
local tb_file=`basename $URL`
local tb_type="tar.gz"
local seed_name="ant"
local deps=(java)
local root_seed="apache-ant-${version}"

do_install()
{
  cd $LOCAL_DIR
  download $URL $tb_file
  decompress_tool $tb_file $tb_type
  clear_env
  for_env " export PATH=\"$LOCAL_DIR/$root_seed/bin:\$PATH\" "
  for_env " export ANT_HOME='$LOCAL_DIR/$root_seed'"
}

do_remove()
{
  rm -rf $LOCAL_DIR/$root_seed*
}

source "$MAIN_DIR/lib/case.sh"
