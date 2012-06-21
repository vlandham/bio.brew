local version="0.7.4"
local seed_name="bismark_v$version"
local platform="Linux_x86_64"
local type="tar.gz"
local URL="http://www.bioinformatics.babraham.ac.uk/projects/bismark/bismark_v${version}.${type}"
local tb_file=`basename $URL`

# note the '.' in the basename call below
local tb_dir=`basename $URL .$type`
local deps=(bowtie)
local external_deps=()
local install_files=(bismark bismark_genome_preparation methylation_extractor)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $TB_DIR/$seed_name $STAGE_DIR/$seed_name
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
