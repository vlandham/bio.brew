local version="1.1.2-484"
local type="tar.gz"
# sourceforge mirror was found by copying download link in 
# Firefox's download manager.
local URL="http://ea-utils.googlecode.com/files/ea-utils.${version}.${type}"
local tb_file=`basename $URL`
local extract_name=`basename $URL .${type}`
local seed_name="ea-utils-${version}"
local install_files=(fastq-clipper fastq-join fastq-mcf fastq-multx fastq-stats sam-stats)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $extract_name $STAGE_DIR/$seed_name
  cd $STAGE_DIR/$seed_name
  make_tool $seed_name $make_j
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
