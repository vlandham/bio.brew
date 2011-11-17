
local version="0.6.0"
local type="tar.bz2"
local seed_name="bwa_${version}"
local URL="http://sourceforge.net/projects/bio-bwa/files/bwa-${version}.${type}"
local tb_file=`basename $URL`
local tb_dir=`basename $tb_file .$type`
local install_files=(bwa solid2fastq.pl)
local deps=("svn")

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $tb_dir $STAGE_DIR/$seed_name
  cd $STAGE_DIR/$seed_name
  make_tool $seed_name $make_j
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
