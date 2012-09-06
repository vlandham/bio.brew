local version="2.2.26"
local type="tar.gz"
local tool_name="blast+"
local URL="ftp://ftp.ncbi.nlm.nih.gov/blast/executables/${tool_name}/${version}/ncbi-blast-${version}+-src.${type}"
local tb_file=`basename $URL`
local tb_name="ncbi-blast-${version}+-src"
local seed_name="blast+_${version}"
local install_files=()

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $TB_DIR/$tb_name $STAGE_DIR/$seed_name
  cd $STAGE_DIR/$seed_name/c++
  configure_tool $seed_name "--without-debug --with-strip --with-mt --with-build-root=ReleaseMT"
  cd ReleaseMT/build
  make all_r
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
