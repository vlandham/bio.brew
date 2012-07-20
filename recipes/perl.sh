local version="5.16.0"
local seed_name="perl-${version}"
local deps=(perlbrew)

do_install()
{
  perlbrew --force install $seed_name
}

do_activate()
{
  perlbrew switch $seed_name
}

do_remove()
{
  log "use perlbrew to manage perl install"
}

source "$MAIN_DIR/lib/case.sh"
