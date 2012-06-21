local version="0.43"
local URL="http://xrl.us/perlbrewinstall"
local seed_name="perlbrew-${version}"

do_install()
{
  cd $STAGE_DIR
  mkdir $seed_name
  export PERLBREW_ROOT=$STAGE_DIR/$seed_name
  curl -Lk http://xrl.us/perlbrewinstall | bash
}

do_activate()
{
  for_env "export PERLBREW_ROOT='$STAGE_DIR/$seed_name'"
  # for_env "export PATH=\\"\\$PERLBREW_ROOT/bin:\\$PATH\\""
  for_env "source $STAGE_DIR/$seed_name/etc/bashrc"
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
