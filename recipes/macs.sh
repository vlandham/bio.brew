# WARNING - INCOMPLETE
local version="2.0.10"
local URL="https://github.com/taoliu/MACS.git"
local seed_name="MACS_$version"
local deps=(python)
local install_files=(bin/macs)

do_install()
{
  cd $STAGE_DIR
  download_git $URL $seed_name
  cd $seed_name
  mkdir install
  python setup.py install --prefix $STAGE_DIR/$seed_name/install
}

do_activate()
{

  # WARNING - INCOMPLETE
  # further work needs to be done to add the binary in install/bin to the path
  # and add the lib/ sub directory to the $PYTHONPATH
  # see https://github.com/taoliu/MACS/blob/macs_v1/INSTALL.rst
  # 
  # as this is just a python module, it can be installed with 
  # pip
  # pip install MACS2
  # link_from_stage $seed_name ${install_files[@]}
}

do_remove()
{
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
}

source "$MAIN_DIR/lib/case.sh"
