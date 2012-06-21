local version="1.9.3-p125"
local seed_name="ruby-${version}"
local deps=(rbenv)

do_install()
{
  rbenv install $version
}

do_activate()
{
  rbenv global $version
}

do_remove()
{
  log "use rbenv to manage ruby"
}

source "$MAIN_DIR/lib/case.sh"
