
local version="5.14.2"
local type="tar.gz"
local URL="http://www.cpan.org/src/5.0/perl-${version}.${type}"
local tb_file=`basename $URL`
local seed_name="perl-${version}"
local install_files=(bin/perl bin/cpan)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR
  cd $STAGE_DIR/$seed_name
  log "Configuring perl"
  # sh Configure -de -Dprefix=$STAGE_DIR/$seed_name &> /dev/null
  sh Configure -de -Dprefix=$LOCAL/$seed_name &> /dev/null
  make_tool $seed_name $make_j
  install_tool $seed_name
}

do_activate()
{
  link_from_stage $seed_name ${install_files[@]}
  link_library $seed_name
  link_man $seed_name
  for_env "export PATH='$STAGE_DIR/current/bin:$PATH'"

  # setup_cpan_config

}

do_remove()
{
  unlink_library $seed_name
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
}

source "$MAIN_DIR/lib/case.sh"
