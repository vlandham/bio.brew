
local version="1.40"
local URL="http://sourceforge.net/projects/picard/files/picard-tools/${version}/picard-tools-${version}.zip/download"
local tb_file=`basename $URL`
local seed_name="picard"
local unzip_dir="picard-tools-${version}"
local deps=(java)

do_install()
{
  cd $LOCAL_DIR
  log "Downloading"
  curl -sL $URL > ${unzip_dir}.zip
  log "Unzipping"
  unzip ${unzip_dir}.zip &> $LOG_DIR/${seed_name}.unzip.log.txt
  rm -f *.zip
  mv $unzip_dir $seed_name
  for_env "export PICARD='$LOCAL_DIR/picard'"
}

do_remove()
{
  rm -rf $LOCAL_DIR/$seed_name
}

source "$MAIN_DIR/lib/case.sh"
