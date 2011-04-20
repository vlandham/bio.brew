
local URL="ftp://ftp.broadinstitute.org/pub/gsa/GenomeAnalysisTK/GenomeAnalysisTK-latest.tar.bz2"
local tb_file=`basename $URL`
local tb_type="tar.bz2"
local seed_name="gatk"
local deps=("java")

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $tb_type
  rm -f $tb_file
  mv GenomeAnalysisTK* ../local/gatk
  for_env "export GATK='$LOCAL_DIR/gatk'"
}

do_remove()
{
  rm -rf $LOCAL_DIR/gatk
}

source "$MAIN_DIR/lib/case.sh"
