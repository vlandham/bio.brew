local version="2.9.2"
local type="tgz"
local URL="http://www.scala-lang.org/downloads/distrib/files/scala-${version}.${type}"
local tb_file=`basename $URL`
local seed_name="scala-${version}"
local install_files=(bin/fsc bin/scala bin/scalac bin/scaladoc bin/scalap)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR/$seed_name
  cd $STAGE_DIR/$seed_name
}

do_activate()
{
  link_from_stage $seed_name ${install_files[@]}
  # for_env "export PATH=\\"$STAGE_DIR/current/bin:\\$PATH\\""
  # for_env "export LD_LIBRARY_PATH=\\"$STAGE_DIR/current/lib:\\$LD_LIBRARY_PATH\\""
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
