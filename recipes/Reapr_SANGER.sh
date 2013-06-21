## THIS IS FOR "REAPR", THE GENOME-ASSEMBLY QC PACKAGE FROM SANGER

## PERL-MODULE DEPENDENCIES: File::Basename,Copy,Spec,Spec::Link; Getopt::long; List::Util
## SUGGESTED: Artemis >= 15.0.0 for visualization, 'SMALT' >= 0.6.4 for read alignments (http://www.sanger.ac.uk/resources/software/smalt/)


local version="1.0.15"
local type="tar.gz"
local URL="ftp://ftp.sanger.ac.uk/pub4/resources/software/reapr/Reapr_$version.$type"
local tb_file=`basename $URL`
local seed_name="Reapr_$version"
local install_files=(reapr)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR
  cd $STAGE_DIR/$seed_name
  ./install.sh
}

do_activate()
{
  link_from_stage $seed_name ${install_files[@]}
  switch_current $seed_name
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
