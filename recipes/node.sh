
local URL="https://github.com/joyent/node.git"
local seed_name="node"
local deps=()
local install_files=(node)

do_install()
{
  cd $LOCAL_DIR
  log "git cloning: $URL"
  git clone $URL &> $LOG_DIR/${seed_name}.git_clone.log.txt
  cd $seed_name
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
