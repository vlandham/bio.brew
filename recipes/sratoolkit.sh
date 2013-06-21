local version="2.3.2-5"
local type="tar.gz"
local URL="http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/$version/sratoolkit.$version-centos_linux64.$type"
local tb_file=`basename $URL`
local seed_name="sratoolkit.$version-centos_linux64"
local install_files=(bin/abi-dump bin/fastq-dump bin/illumina-dump bin/kar bin/sam-dump bin/sff-dump bin/sra-dbcc bin/sra-pileup bin/vdb-dump bin/vdb-encrypt bin/vdb-decrypt bin/vdb-validate)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR
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
}

source "$MAIN_DIR/lib/case.sh"
