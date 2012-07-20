local version="2.0.0"
local seed_name="tophat_$version"
local platform="Linux_x86_64"
local type="tar.gz"
local URL="http://tophat.cbcb.umd.edu/downloads/tophat-${version}.${platform}.${type}"
local tb_file=`basename $URL`
# note the '.' in the basname call below
local tb_dir=`basename $URL .$type`
# should be dependent on bowtie and samtools at least.
# not adding those dependencies now as we currently have them installed via alternate system
local deps=()
local external_deps=()
local install_files=(wiggles bam_merge bam2fastx bed_to_juncs closure_juncs contig_to_chr_coords extract_reads fix_map_ordering gtf_juncs juncs_db library_stats long_spanning_reads mask_sam prep_reads sam_juncs segment_juncs sra_to_solid tophat tophat_reports)

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
