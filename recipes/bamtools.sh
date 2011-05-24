local version="1.0.2"
local URL="https://github.com/pezmaster31/bamtools"
local seed_name="bamtools_$version"
local deps=()
local external_deps=(cmake)
local install_files=(bin/bamtools)

do_install()
{
  cd $STAGE_DIR
  download_git $URL $seed_name
  cd $seed_name
  mkdir build
  cd build
  cmake ..
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
