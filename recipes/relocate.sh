local version="1.0.3"
local type="zip"
# sourceforge mirror was found by copying download link in 
# Firefox's download manager.
local URL="https://github.com/srobb1/RelocaTE/archive/RelocaTE-1-0-3-noBioPerl.zip"
local tb_file=`basename $URL`
local seed_name="relocate-${version}"
#local install_files=(samtools misc/samtools.pl bcftools/bcftools bcftools/vcfutils.pl)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  cd $seed_name
  make_tool $seed_name $make_j
  cd ..
  mv $seed_name $STAGE_DIR
}

do_activate()
{
  for_env "export SAMTOOLS_DIR='$STAGE_DIR/$seed_name'"
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
