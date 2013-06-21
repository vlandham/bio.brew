local version="0.7.4"
local type="tar.gz"
local URL="ftp://ftp.sanger.ac.uk/pub4/resources/software/smalt/smalt-$version.tgz";
local tb_file=`basename $URL`
local seed_name="smalt-${version}"

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR
}

do_activate()
{
  ln -s $STAGE_DIR/$seed_name/smalt_x86_64 /n/local/bin/smalt
  switch_current $seed_name
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
