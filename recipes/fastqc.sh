
local version="0.9.1"
local URL="http://www.bioinformatics.bbsrc.ac.uk/projects/fastqc/fastqc_v0.9.1.zip"
local zip_file=`basename $URL`
local seed_name="fastqc_$version"
local unzip_dir="FastQC"
local dep=("java")
do_install()
{
  cd $STAGE_DIR
  log "Downloading"
  curl -sL $URL > ${zip_file}
  log "Unzipping ($zip_file)"
  unzip $zip_file &> $LOG_DIR/${seed_name}.unzip.log.txt
  mv $unzip_dir $seed_name
  rm -f $zip_file
  cd ..
  chmod 755 $STAGE_DIR/$seed_name/fastqc
  ln -s $STAGE_DIR/$seed_name $STAGE_DIR/current
  ln -s $STAGE_DIR/current/fastqc $LOCAL_DIR/bin/fastqc
}

do_remove()
{
  rm -rf $STAGE_DIR/$seed_name
  rm -f $LOCAL_DIR/bin/fastqc
  rm -f $STAGE_DIR/current
}

source "$MAIN_DIR/lib/case.sh"
