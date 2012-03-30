
local version="1.5.64"
local type="zip"
local URL="http://www.broadinstitute.org/igvdata/downloads/IGV_${version}.${type}"
local tb_file=`basename $URL`
local seed_name="igv-${version}"
local unzip_dir="IGV_${version}"
local deps=(java)
local install_files=(igv.jar batik-codec.jar igv_linux-64.sh)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $unzip_dir $seed_name
  mv $seed_name $STAGE_DIR
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
