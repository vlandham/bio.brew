local version="69"
local type="tar.gz"
local URLS=("http://cvs.sanger.ac.uk/cgi-bin/viewvc.cgi/ensembl.tar.gz?root=ensembl&only_with_tag=branch-ensembl-69&view=tar" "http://cvs.sanger.ac.uk/cgi-bin/viewvc.cgi/ensembl-compara.tar.gz?root=ensembl&only_with_tag=branch-ensembl-69&view=tar" "http://cvs.sanger.ac.uk/cgi-bin/viewvc.cgi/ensembl-variation.tar.gz?root=ensembl&only_with_tag=branch-ensembl-69&view=tar" "http://cvs.sanger.ac.uk/cgi-bin/viewvc.cgi/ensembl-functgenomics.tar.gz?root=ensembl&only_with_tag=branch-ensembl-69&view=tar")
local BIOPERL_URL="http://bioperl.org/DIST/old_releases/bioperl-1.2.3.tar.gz"
local seed_name="ensembl_perl-${version}"

local names=(bioperl-1.2.3 ensembl ensembl-compara ensembl-variation ensembl-functgenomics)
local install_files=()

do_install()
{
  cd $STAGE_DIR
  mkdir -p $STAGE_DIR/$seed_name/downloads
  cd $STAGE_DIR/$seed_name/downloads

  for url in ${URLS[@]}
  do
    local tb_file=`basename $url`
    download $url $tb_file
    decompress_tool $tb_file $type
  done

  local bioperl_tar=`basename $BIOPERL_URL`
  download $BIOPERL_URL $bioperl_tar
  decompress_tool $bioperl_tar $type

  cd $STAGE_DIR/$seed_name/downloads

  for name in ${names[@]}
  do
    mv $name ../
  done
}

do_activate()
{

  switch_current $seed_name
  local output_file=$STAGE_DIR/ensembl_perl.sh
  touch $output_file
  local root_dir=$STAGE_DIR/current
  echo "" > $output_file

  for name in ${names[@]}
  do
    echo "PERL5LIB=$root_dir/$name:\$PERL5LIB" >> $output_file
    echo "PERL5LIB=$root_dir/$name/modules:\$PERL5LIB" >> $output_file
  done

  echo "export PERL5LIB" >> $output_file
  # for_env "export SAMTOOLS_DIR='$STAGE_DIR/$seed_name'"
  # link_from_stage $seed_name ${install_files[@]}
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
