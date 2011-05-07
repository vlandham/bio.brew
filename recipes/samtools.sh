local version="0.1.16"
local URL="https://sourceforge.net/projects/samtools/files/samtools/0.1.16/samtools-${version}.tar.bz2"
local tb_file=`basename $URL`
local type="tar.bz2"
local seed_name="samtools-${version}"
local install_files=(samtools misc/samtools.pl bcftools/bcftools bcftools/vcfutils.pl)

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
