
# don't know actual version. look it up if we need this package
local version="0.1"
local URL="git://dnaa.git.sourceforge.net/gitroot/dnaa/dnaa"
local tb_file=`basename $URL`
local seed_name="dnaa-${version}"
local deps=("samtools" "bfast")
local install_files=(dwgsim/dwgsim dwgsim/dwgsim_eval dwgsim/dwgsim_pileup_eval.pl dtranslocations/dtranslocations dutil/dbamstats dutil/dbampairedenddist)

do_install()
{
  cd $STAGE_DIR
  log "git cloning: $URL"
  git clone $URL $seed_name &> $LOG_DIR/${seed_name}.git_clone.log.txt
  cd $seed_name
  # ln -s ../bfast
  # ln -s ../samtools

  log "autogen"
  sh ./autogen.sh &> $LOG_DIR/${seed_name}.autogen.log.txt
  configure_tool $seed_name 
  make_tool $seed_name $make_j
}

do_activate()
{
  link_from_stage $seed_name ${install_files[@]}
}

do_remove()
{
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
}

source "$MAIN_DIR/lib/case.sh"
