local version="0.0.13.2"
local type="tar.bz2"
local URL="http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit-${version}.${type}"
local tb_file=`basename $URL`
local deps=(libgtextutils)
local seed_name="fastx_toolkit-${version}"
local install_files=(bin/fastq_to_fasta bin/fastx_quality_stats bin/fastx_clipper bin/fastx_renamer bin/fastx_trimmer bin/fastx_collapser bin/fastx_artifacts_filter bin/fastq_quality_filter bin/fastx_reverse_complement bin/fasta_formatter bin/fasta_nucleotide_changer scripts/fasta_clipping_histogram.pl scripts/fastx_barcode_splitter.pl)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $TB_DIR/$seed_name $STAGE_DIR/$seed_name
  cd $STAGE_DIR/$seed_name
  export PKG_CONFIG_PATH="/n/local/lib/pkgconfig:$PKG_CONFIG_PATH"
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
