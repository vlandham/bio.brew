local version="r223"
local seed_name="soapdenovo2_$version"
local platform="LINUX-generic"
local type="tgz"
local URL="http://downloads.sourceforge.net/project/soapdenovo2/SOAPdenovo2/bin/${version}/SOAPdenovo2-bin-${platform}-${version}.${type}"
local tb_file=`basename $URL`
local extract_name=`basename $URL .$type`
local deps=()
local external_deps=()
local install_files=(pregraph_sparse_63mer.v1.0.3 pregraph_sparse_127mer.v1.0.3 SOAPdenovo-63mer SOAPdenovo-127mer)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mkdir $STAGE_DIR/$seed_name
  for file in ${install_files[@]}
  do
    echo $file
    mv $TB_DIR/$file $STAGE_DIR/$seed_name
  done
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
