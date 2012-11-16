local version="5.16.1"
local seed_name="perl-${version}"
local threaded_seed_name="perl-${version}t"
local deps=(perlbrew)

do_install()
{
  perlbrew --force install $seed_name
  perlbrew --force install $seed_name -Dusethreads --as ${threaded_seed_name}
}

do_activate()
{
  perlbrew switch $threaded_seed_name
}

do_remove()
{
  log "use perlbrew to manage perl install"
}

source "$MAIN_DIR/lib/case.sh"
