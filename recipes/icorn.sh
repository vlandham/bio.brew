
## DEPENDENCIES: SSAHA_pileup >= 0.5, SNP-O-Matic


local version="0.97"
local type="tar.gz"
local URL="http://downloads.sourceforge.net/project/icorn/iCORN-v$version.$type?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Ficorn%2Ffiles%2F&ts=1371085343&use_mirror=hivelocity"
local tb_file=`basename $URL`
local seed_name="iCORN-v$version"

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR
  cd $STAGE_DIR/$seed_name
  echo "
  $STAGE_DIR/$seed_name/icorn.start.sh \$1 \$2 \$3 \$4 \$5 \$6 \$7
  " > icorn.sh
  mkdir original_code
  cp * original_code
  /n/local/bin/bio.brew/resources/iCORN/apa_code_modifications
}

do_activate()
{
  ln -s $STAGE_DIR/$seed_name/icorn.sh /n/local/bin/icorn
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
