
local version="0.7.0"
local revision="a"
local tool_name="bfast"
local type="tar.gz"
local URL="softlayer.dl.sourceforge.net/project/${tool_name}/${tool_name}/${version}/${tool_name}-${version}${revision}.${type}"
local tb_file=`basename $URL`
local seed_name="bfast-${version}"
local install_files=(bfast/bfast scripts/solid2fastq scripts/ill2fastq.pl)

do_install()
{
  cd $STAGE_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv "${seed_name}${revision}" $seed_name
  cd $seed_name
  log "autogen"
  sh ./autogen.sh &> $LOG_DIR/${seed_name}.autogen.log.txt
  configure_tool $seed_name 
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
