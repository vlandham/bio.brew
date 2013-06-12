
#local version="1.1-37-ge63d9d8"
# local version="1.2-62-g41ddc7b"
# local version="1.4-37-g0b29d54"
local version="2.4-9"
local real_version="2.4-9-g532efad"
local type="tar.bz2"

# as you have to sign in and agree to statement 
# right now the Tarball is expected to just already 
# be in the TARBALL directory
# local URL="ftp://ftp.broadinstitute.org/pub/gsa/GenomeAnalysisTK/GenomeAnalysisTK-${version}.${type}"
local tb_file="GenomeAnalysisTK-${version}.${type}"
local tb_dir="GenomeAnalysisTK-${real_version}"
local seed_name="gatk_${version}"
local deps=("java")

do_install()
{
  cd $TB_DIR
  # download $URL $tb_file
  decompress_tool $tb_file $type
  mv $tb_dir $STAGE_DIR/$seed_name
}

do_activate()
{
  rm -rf $STAGE_DIR/current
  ln -s $STAGE_DIR/$seed_name $STAGE_DIR/current
  for_env "export GATK='$STAGE_DIR/current'"
}

do_remove()
{
  rm -rf $STAGE_DIR/$seed_name
}

source "$MAIN_DIR/lib/case.sh"
