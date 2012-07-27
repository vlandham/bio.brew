local version="0.42"
local URL="https://github.com/discoproject/disco"
local seed_name="disco_$version"
local deps=(erlang)
local install_files=(bin/disco)

do_install()
{
  cd $STAGE_DIR
  download_git $URL $seed_name
  cd $seed_name
  make
  cd ..
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
