local version="2.1.0"
local type="zip"
local os=`uname -s`
local bowtie_os="linux"
if [ "$os" == "Darwin" ] ; then
  bowtie_os="macos"
fi
local URL="http://downloads.sourceforge.net/project/bowtie-bio/bowtie2/${version}/bowtie2-${version}-${bowtie_os}-x86_64.${type}"
local tb_file=`basename $URL`
local seed_name="bowtie2-${version}"
local install_files=(bowtie2 bowtie2-align bowtie2-build bowtie2-inspect)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $TB_DIR/$seed_name $STAGE_DIR/$seed_name
  cd $STAGE_DIR/$seed_name
}

do_activate()
{
  link_from_stage $seed_name ${install_files[@]}
}

do_test()
{
  $STAGE_DIR/$seed_name/bowtie2 -x /n/data1/genomes/bowtie-index/sacCer2/sacCer2 -U $BB_PATH/tests/sample_yeast.fastq
}

do_remove()
{
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
}

source "$MAIN_DIR/lib/case.sh"
