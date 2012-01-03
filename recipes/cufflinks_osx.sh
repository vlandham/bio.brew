local version="1.3.0"
local seed_name="cufflinks_$version"
local type="tar.gz"
local URL="http://cufflinks.cbcb.umd.edu/downloads/cufflinks-${version}.OSX_x86_64.${type}"
local tb_file=`basename $URL`
# note the '.' in the basname call below
local tb_dir=`basename $URL .$type`
# should be dependent on bowtie and samtools at least.
# not adding those dependencies now as we currently have them installed via alternate system
local deps=()
local external_deps=()
local install_files=(cufflinks cuffcompare cuffdiff cuffmerge gffread gtf_to_sam)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $tb_dir $seed_name
  mv $seed_name $STAGE_DIR
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
