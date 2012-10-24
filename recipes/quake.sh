local version="0.3.4"
local type="tar.gz"
# sourceforge mirror was found by copying download link in 
# Firefox's download manager.
local URL="http://www.cbcb.umd.edu/software/quake/downloads/quake-${version}.${type}"
local tb_file=`basename $URL`
local untar_name="Quake"
local seed_name="quake-${version}"
local install_files=(samtools misc/samtools.pl bcftools/bcftools bcftools/vcfutils.pl)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $untar_name $STAGE_DIR/$seed_name
  cd $STAGE_DIR/$seed_name
  # make_tool $seed_name $make_j
  # cd ..
}

do_activate()
{
  switch_current $seed_name
  for_env "export PATH=\"$STAGE_DIR/current/bin:\$PATH\""
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
