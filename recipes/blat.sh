local version="34"
local type="zip"
local URL="http://hgwdev.cse.ucsc.edu/~kent/src/blatSrc${version}.${type}"
local tb_file=`basename $URL`
local seed_name="blatSrc"
local install_files=(bin/blat bin/pslPretty bin/pslReps bin/pslSort)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  cd $seed_name
  export MACHTYPE="x86_64"
  mkdir -p $HOME/bin/$MACHTYPE
  make &> $LOG_DIR/${seed_name}.make.log.txt
  cd ..
  mv $HOME/bin/$MACHTYPE ./$seed_name/bin
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
