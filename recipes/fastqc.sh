
local version="0.10.1"
local type="zip"
local URL="http://www.bioinformatics.bbsrc.ac.uk/projects/fastqc/fastqc_v${version}.${type}"
local zip_file=`basename $URL`
local seed_name="fastqc_$version"
local unzip_dir="FastQC"
local deps=("java")
local install_files=(fastqc)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $zip_file $type
  mv $unzip_dir $STAGE_DIR/$seed_name
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
