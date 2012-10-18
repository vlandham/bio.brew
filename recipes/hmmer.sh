local version="3.0"
local type="tar.gz"
local URL="ftp://selab.janelia.org/pub/software/hmmer3/${version}/hmmer-${version}-linux-intel-x86_64.${type}"
local tb_file=`basename $URL`
local seed_name="hmmer-${version}-linux-intel-x86_64"
local install_files=(bin/hmmalign bin/hmmbuild bin/hmmconvert bin/hmmemit bin/hmmfetch bin/hmmpress bin/hmmscan bin/hmmsearch bin/hmmsim bin/hmmstat bin/jackhmmer bin/phmmer)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $TB_DIR/$seed_name $STAGE_DIR/$seed_name
  cd $STAGE_DIR/$seed_name
  configure_tool $seed_name
  make_tool $seed_name $make_j
  install_tool $seed_name
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
