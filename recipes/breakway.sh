
local version="0.7"
local type="tar.gz"
local URL="http://sourceforge.net/projects/breakway/files/breakway.${version}/breakway.${version}.${type}/download"
local deps=("perl-5.12.2" "p5_Math_CDF")
local seed_name="breakway-${version}"
local tb_file=`basename $URL`
local install_files=(breakway.run.pl scripts/breakway.parameters.pl)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv `basename $tb_file $type` $STAGE_DIR/$seed_name
  cd $STAGE_DIR/$seed_name
}

do_activate()
{
  link_from_stage $seed_name ${install_files[@]}
}

do_remove()
{
  rm -rf $LOCAL_DIR/$root_seed*
}

source "$MAIN_DIR/lib/case.sh"
