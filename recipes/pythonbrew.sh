local version="1.0"
local URL="http://xrl.us/pythonbrewinstall"
local seed_name="pythonbrew-${version}"
local external_deps="python"

do_install()
{
  cd $STAGE_DIR
  mkdir $seed_name
  export PYTHONBREW_ROOT=$STAGE_DIR/$seed_name
  curl -kLO $URL
  chmod +x pythonbrewinstall
  ./pythonbrewinstall
}

do_activate()
{
  for_env "export PYTHONBREW_ROOT='$STAGE_DIR/$seed_name'"
  for_env "[[ -s $STAGE_DIR/$seed_name/etc/bashrc ]] && source $STAGE_DIR/$seed_name/etc/bashrc"
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
