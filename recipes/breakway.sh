
local version="0.7"
local URL="http://sourceforge.net/projects/breakway/files/breakway.${version}/breakway.${version}.tar.gz/download"
local tb_type="tar.gz"
local seed_name="breakway"
local deps=("perl-5.12.2" "p5_Math_CDF")
local root_seed="breakway.${version}"
local tb_file=${root_seed}.${tb_type}
local install_files=(breakway.run.pl scripts/breakway.parameters.pl)

do_install()
{
  cd $LOCAL_DIR
  log "Downloading ${root_seed}"
  curl -sL $URL > $tb_file
  decompress_tool $tb_file $tb_type
  rm -f $tb_file
  cd $root_seed
  link_from_stage $root_seed ${install_files[@]} 
}

do_remove()
{
  rm -rf $LOCAL_DIR/$root_seed*
}

source "$MAIN_DIR/lib/case.sh"
