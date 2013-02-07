
local version="0.22"
local type="zip"
local URL="http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-${version}.${type}"
local tb_file=`basename $URL`
local seed_name="Trimmomatic-${version}"
local jar_file="trimmomatic-${version}.jar"
local deps=(java)
local install_files=(trimmomatic-${version}.jar)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR/$seed_name
}

do_activate()
{
  switch_current $seed_name
  ln -s $STAGE_DIR/$seed_name/${jar_file} $BIN_DIR

  for_env "export TRIMMOMATIC='$STAGE_DIR/current/${jar_file}'"
}

do_test()
{
  log "test"
}

do_remove()
{
  remove_recipe $seed_name
}

source "$MAIN_DIR/lib/case.sh"
