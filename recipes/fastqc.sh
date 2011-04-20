
local version="0.7.0"
local URL="http://www.bioinformatics.bbsrc.ac.uk/projects/fastqc/fastqc_v0.7.0.zip"
local zip_file=`basename $URL`
local seed_name="fastqc"
local unzip_dir="FastQC"
local deps=(java)

do_install()
{
  cd $LOCAL_DIR
  log "Downloading"
  curl -sL $URL > ${zip_file}
  log "Unzipping ($zip_file)"
  unzip $zip_file &> $LOG_DIR/${seed_name}.unzip.log.txt
  rm -f $zip_file
  chmod 755 $LOCAL_DIR/$unzip_dir/fastqc
  ln -s $LOCAL_DIR/$unzip_dir/fastqc ./bin/fastqc
}

do_remove()
{
  rm -rf $LOCAL_DIR/$unzip_dir
  rm -f $LOCAL_DIR/bin/fastqc
}

source "$MAIN_DIR/lib/case.sh"
