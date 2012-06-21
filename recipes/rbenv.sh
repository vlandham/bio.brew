local version="0.3.0"
local URL="git://github.com/sstephenson/rbenv.git"
local RB_BUILD_URL="git://github.com/sstephenson/ruby-build.git"
local seed_name="rbenv-${version}"
# local install_files=(bin/rbenv bin/ruby-local-exec)

do_install()
{
  cd $STAGE_DIR
  download_git $URL $seed_name
  mkdir $seed_name/plugins
  cd $seed_name/plugins
  download_git $RB_BUILD_URL "ruby-build"
}

do_activate()
{
  for_env "export RBENV_ROOT='$STAGE_DIR/$seed_name'"
  for_env "export PATH=\"\$RBENV_ROOT/shims:\$RBENV_ROOT/bin:\$PATH\""
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
