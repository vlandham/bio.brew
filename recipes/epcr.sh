local version="2.3.11"
local type="tar.gz"
local URL="ftp://ftp.ncbi.nlm.nih.gov/pub/schuler/e-PCR/e-PCR-${version}-x86_64-linux.${type}"
local tb_file=`basename $URL`
local untar_name="Linux-x86_64"
local seed_name="epcr-${version}"
local install_files=(e-PCR re-PCR famap fahash)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $untar_name $STAGE_DIR/$seed_name
  cd $STAGE_DIR/$seed_name
}

do_activate()
{
  link_from_stage $seed_name ${install_files[@]}
}

do_test()
{
	log "test"
}

do_remove()
{
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
}

source "$MAIN_DIR/lib/case.sh"
