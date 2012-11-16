local version="1.3.1"
local URL="https://github.com/metalhelix/bam_stats.git"
local seed_name="bam_stats_$version"
local deps=()
local external_deps=()
local install_files=(bam_stats)

do_install()
{
  cd $STAGE_DIR
  download_git $URL $seed_name
  cd $seed_name
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
