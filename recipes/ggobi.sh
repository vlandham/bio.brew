
local version="2.1.9"
local type="tar.bz2"
local URL="http://www.ggobi.org/downloads/ggobi-2.1.9.tar.bz2"
local tb_file=`basename $URL`
local extract_name="ggobi-${version}"
local seed_name="ggobi_$version"
local tb_dir="ggobi"
local install_files=()

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $extract_name $STAGE_DIR/$seed_name
  cd $STAGE_DIR/$seed_name
  configure_tool $seed_name "--with-all-plugins" "$STAGE_DIR/$seed_name/install"
  make_tool $seed_name
  install_tool $seed_name
  make "$STAGE_DIR/$seed_name/ggobirc"
  mkdir -p /n/local/etc/xdg/ggobi
  cp $STAGE_DIR/$seed_name/ggobirc /n/local/etc/xdg/ggobi/ggobirc
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
