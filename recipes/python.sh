local version="2.7.2"
local seed_name="python-${version}"
local deps=(pythonbrew)

do_install()
{
  pythonbrew install $version
}

do_activate()
{
  pythonbrew switch $version
}

do_remove()
{
  log "use pythonbrew to manage python install"
}

source "$MAIN_DIR/lib/case.sh"
