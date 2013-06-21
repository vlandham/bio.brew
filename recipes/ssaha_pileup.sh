local version="0.6"
local type="tar.gz"
local URL="ftp://ftp.sanger.ac.uk/pub4/resources/software/ssaha2/pileup.tgz";
local tb_file=`basename $URL`
local seed_name="pileup_v$version"
local install_files=(ssaha_pileup/ssaha_pileup/ssaha_check-cigar ssaha_pileup/ssaha_pileup/ssaha_cigar ssaha_pileup/ssaha_pileup/ssaha_clean ssaha_pileup/ssaha_pileup/ssaha_indel ssaha_pileup/ssaha_pileup/ssaha_mates ssaha_pileup/ssaha_pileup/ssaha_merge ssaha_pileup/ssaha_pileup/ssaha_pairs ssaha_pileup/ssaha_pileup/ssaha_pileup ssaha_pileup/ssaha_pileup/ssaha_reads ssaha_pileup/ssaha_pileup/ssaha_solexa ssaha_pileup/ssaha_pileup/view_pileup)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR
  cd $STAGE_DIR/$seed_name
  ./install.csh
}

do_activate()
{
  ln -s $STAGE_DIR/$seed_name/ssaha2/ssaha2-2.3_x86_64 /n/local/bin/ssaha2
  link_from_stage $seed_name ${install_files[@]}
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
