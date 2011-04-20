
local URL="https://samtools.svn.sourceforge.net/svnroot/samtools"
local tb_file=`basename $URL`
local seed_name="samtools"
local install_files=(samtools misc/samtools.pl bcftools/bcftools bcftools/vcfutils.pl)
local deps=("subversion-1.6.13")

do_install()
{
  cd $LOCAL_DIR
  log "svn: checking out $URL"
  svn co $URL $seed_name &> $LOG_DIR/${seed_name}.svn_co.log.txt
  mv $seed_name/trunk/$seed_name ./s
  rm -rf $seed_name
  mv ./s $seed_name
  cd $seed_name
  make_tool $seed_name $make_j
  link_from_stage $recipe ${install_files[@]}
}

do_remove()
{
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
}

source "$MAIN_DIR/lib/case.sh"
