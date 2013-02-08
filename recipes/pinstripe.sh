local version="0.0.1"
local type="zip"
local URL="http://pinstripe.matticklab.com/Files/pinstripe.${type}"
local tb_file=`basename $URL`
local seed_name="pinstripe-${version}"
local install_files=(pstr)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mkdir  $STAGE_DIR/$seed_name
  mv bedHelper.exe $STAGE_DIR/$seed_name
  mv pinstripe.exe $STAGE_DIR/$seed_name
  cd $STAGE_DIR/$seed_name 
  # quick hack to make an executable
  touch pstr
  chmod +x pstr
  echo "#!/bin/sh" >> pstr
  echo "mono $STAGE_DIR/$seed_name/pinstripe.exe \"\$@\"" >> pstr
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
