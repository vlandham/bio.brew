local version="34"
local type="zip"
local tool_name="blatSrc"
local URL="http://hgwdev.cse.ucsc.edu/~kent/src/${tool_name}${version}.${type}"
local tb_file=`basename $URL`
local seed_name="blat-${version}"
local install_files=(bin/blat bin/pslPretty bin/pslReps bin/pslSort)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $tool_name $seed_name
  cd $seed_name
  export MACHTYPE="x86_64"
  # we will move this directory out of $HOME below
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
