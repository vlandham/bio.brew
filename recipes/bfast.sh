
local URL="git://bfast.git.sourceforge.net/gitroot/bfast/bfast"
local tb_file=`basename $URL`
local seed_name="bfast"
local install_files=(bfast/bfast scripts/solid2fastq scripts/ill2fastq.pl)

do_install()
{
  cd $LOCAL_DIR
  log "git cloning: $URL"
  git clone $URL &> $LOG_DIR/${seed_name}.git_clone.log.txt
  cd $seed_name
  log "autogen"
  sh ./autogen.sh &> $LOG_DIR/${seed_name}.autogen.log.txt
  configure_tool $seed_name 
  make_tool $seed_name $make_j
  link_from_stage $recipe ${install_files[@]}
}

do_remove()
{
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
}

source "$MAIN_DIR/lib/case.sh"
