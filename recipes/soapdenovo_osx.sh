local version="1.05"
local seed_name="soapdenovo_$version"
local platform="MACOSX"
local type="tgz"
local base_URL="http://soap.genomics.org.cn/down/${platform}/"
local URL1="http://soap.genomics.org.cn/down/${platform}/SOAPdenovo31mer.${type}"
local URL2="http://soap.genomics.org.cn/down/${platform}/SOAPdenovo63mer.${type}"
local URL3="http://soap.genomics.org.cn/down/${platform}/SOAPdenovo127mer.${type}"
#local tb_file=`basename $URL`
# note the '.' in the basname call below
#local tb_dir=`basename $URL .$type`
local deps=()
local external_deps=()
local install_files=(SOAPdenovo31mer SOAPdenovo63mer SOAPdenovo127mer)

do_install()
{
  cd $TB_DIR

  for file in ${install_files[@]} 
  do
    local URL="${base_URL}${file}.${type}"
    local tb_file=`basename $URL`
    local tb_dir=`basename $URL .$type`
    download $URL $tb_file
    decompress_tool $tb_file $type
    mkdir -p $seed_name
    mv $file $seed_name
  done
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
