local version="4.7.0"
local type="tar.gz"
# sourceforge mirror was found by copying download link in 
# Firefox's download manager.
local URL="http://meme.nbcr.net/downloads/meme_${version}.${type}"
local tb_file=`basename $URL`
local seed_name="meme_${version}"
local install_files=(samtools misc/samtools.pl bcftools/bcftools bcftools/vcfutils.pl)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  cd $seed_name
  configure_tool $seed_name 
  make_tool $seed_name $make_j
  cd ..
  mv $seed_name $STAGE_DIR
  cd $STAGE_DIR
  cd $seed_name
  install_tool $seed_name
}

do_activate()
{
  switch_current $seed_name
  for_env "PATH='$STAGE_DIR/current/bin:$PATH'"
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
