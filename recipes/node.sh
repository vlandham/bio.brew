local version="0.5.0-pre"
local URL="https://github.com/joyent/node.git"
local seed_name="node_$version"
local deps=()
local install_files=(node)

do_install()
{
  cd $STAGE_DIR
  download_git $URL $seed_name
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
