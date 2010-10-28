
local URL="https://bio-bwa.svn.sourceforge.net/svnroot/bio-bwa"
local tb_file=`basename $URL`
local seed_name="bwa"
local install_files=(bwa solid2fastq.pl)

do_install()
{
  before_install $seed_name
  cd $LOCAL_DIR
  svn co $URL $seed_name
  cd $seed_name
  svn $URL $seed_name &> $LOG_DIR/${seed_name}.svn.log.txt
  cd ..
  mv $seed_name/trunk/$seed_name ../b
  rm -rf $seed_name
  mv ./b $seed_name
  cd $seed_name
  sh ./autogen.sh 
  make 
  link_from_stage $recipe ${install_files[@]}
  after_install $recipe
}

do_remove()
{
  before_remove $seed_name
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
  after_remove $seed_name
}

source "$MAIN_DIR/lib/case.sh"
