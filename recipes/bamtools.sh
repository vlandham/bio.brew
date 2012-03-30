# I cannot find any documentation about 
# where the version of bamtools is located and when it changes.
# Nor does it look like they are currently releasing versioned packages
# of their code (which is unfortunate and lame). 
# 
# BUT bamtools does have a version associated with it
# bamtools version produces it.
#
# Best way I've found so far to deal with this is
# bb install bamtools from github, then look at the version, then bb remove,
#  change the version number in the recipe, and bb install again
#
# (not quite as aweful as it sounds - but pretty close).
# local version="1.0.2"
local version="2.1.1"
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
