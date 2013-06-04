local version="1.0.0"
local type="zip"
local URL="http://downloads.sourceforge.net/project/bowtie-bio/bowtie/${version}/bowtie-${version}-src.${type}"
local tb_file=`basename $URL`
local seed_name="bowtie-${version}"
local install_files=(bowtie bowtie-build bowtie-inspect)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $TB_DIR/$seed_name $STAGE_DIR/$seed_name
  cd $STAGE_DIR/$seed_name
  make_tool $seed_name $make_j
}

do_activate()
{
  link_from_stage $seed_name ${install_files[@]}
}

do_test()
{
  $STAGE_DIR/$seed_name/bowtie /n/data1/genomes/igenome/Mus_musculus/UCSC/mm9/Sequence/BowtieIndex/genome $BB_PATH/tests/sample.fastq
}

do_remove()
{
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
}

source "$MAIN_DIR/lib/case.sh"
