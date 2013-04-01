# WARNING - INCOMPLETE
local version="1.4.2"
local type="tar.gz"
local URL="https://github.com/downloads/taoliu/MACS/MACS-${version}-1.${type}"
local tb_file=`basename $URL`
local extract_name="MACS-${version}"
local seed_name="macs14_$version"
local deps=(python)
local install_dir="${STAGE_DIR}/${seed_name}/install"
local install_files=("install/bin/macs14")

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $extract_name $STAGE_DIR/$seed_name
  cd $STAGE_DIR/$seed_name
  mkdir $install_dir
  python setup.py install --prefix $install_dir
}

do_activate()
{

  link_from_stage $seed_name ${install_files[@]}
  python_lib_path="${install_dir}/lib/python2.7/site-packages"

  # WARNING - this hack might break things. 
  # right now, it would appear that the pythonbrew env script 
  # bulldozes the existing PYTHONPATH variable...
  # so we need to just symlink macs14 stuff into the current path?
  # very brittle. 
  #
  # what would be a better way to do this?

  for_env "export MACSPYTHONPATH=$python_lib_path"
}

do_remove()
{
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
}

source "$MAIN_DIR/lib/case.sh"
