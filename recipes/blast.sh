local version="2.2.26"
local type="tar.gz"
local tool_name="blast"
local URL="ftp://ftp.ncbi.nlm.nih.gov/${tool_name}/executables/release/${version}/${tool_name}-${version}-x64-linux.${type}"
local tb_file=`basename $URL`
local seed_name="blast-${version}"
local install_files=(bin/bl2seq bin/blastclust bin/copymat bin/formatdb bin/impala bin/megablast bin/seedtop bin/blastall bin/blastpgp bin/fastacmd bin/formatrpsdb bin/makemat bin/rpsblast)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $TB_DIR/$seed_name $STAGE_DIR/$seed_name
}

do_activate()
{
  link_from_stage $seed_name ${install_files[@]}
  for_env "export BLASTDB='/n/data1/blast/db'"
  for_env "export BLASTMAT=$STAGE_DIR/$seed_name/data'"
}

do_remove()
{
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
}

source "$MAIN_DIR/lib/case.sh"
