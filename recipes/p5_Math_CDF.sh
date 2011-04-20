
local seed_name="p5_Math_CDF"
local deps=("perl-5.12.2")
local p_module="Math::CDF"

do_install()
{
  cpan_install $p_module
}

do_remove()
{
  cpan_remove $p_module
}

source "$MAIN_DIR/lib/case.sh"
