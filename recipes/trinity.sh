local version="r2012-03-17"
local type="tgz"
local tb_file="trinityrnaseq_${version}.${type}"
local URL="http://sourceforge.net/projects/trinityrnaseq/files/${tb_file}"
local seed_name="trinityrnaseq_${version}"
local install_files=(Trinity.pl)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $TB_DIR/$seed_name $STAGE_DIR/$seed_name
  cd $STAGE_DIR/$seed_name 
  echo "$STAGE_DIR/$seed_name"
  make_tool $seed_name $make_j
  cp -r $STAGE_DIR/$seed_name ../trinity
}

do_activate()
{
  link_from_stage $seed_name ${install_files[@]}
}

do_test()
{
  $STAGE_DIR/$seed_name/Trinity.pl --seqType fq --left $STAGE_DIR/../../stowers.bio.brew/tests/sample.fastq
}

do_remove()
{
  remove_recipe $seed_name
}

source "$MAIN_DIR/lib/case.sh"
