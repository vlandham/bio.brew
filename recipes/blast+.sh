local version="2.2.26"
local type="tar.gz"
local tool_name="blast+"
local URL="ftp://ftp.ncbi.nlm.nih.gov/blast/executables/${tool_name}/${version}/ncbi-blast-${version}+-src.${type}"
local tb_file=`basename $URL`
local tb_name="ncbi-blast-${version}+-src"
local seed_name="blast+_${version}"
local install_files=(c++/ReleaseMT/bin/blastdb_aliastool c++/ReleaseMT/bin/blastdbcmd c++/ReleaseMT/bin/blast_formatter c++/ReleaseMT/bin/blastp c++/ReleaseMT/bin/convert2blastmask c++/ReleaseMT/bin/deltablast c++/ReleaseMT/bin/gene_info_reader c++/ReleaseMT/bin/makeblastdb c++/ReleaseMT/bin/makeprofiledb c++/ReleaseMT/bin/psiblast c++/ReleaseMT/bin/rpstblastn c++/ReleaseMT/bin/seqdb_demo c++/ReleaseMT/bin/tblastn c++/ReleaseMT/bin/test_pcre c++/ReleaseMT/bin/windowmasker c++/ReleaseMT/bin/blastdbcheck c++/ReleaseMT/bin/blastdbcp c++/ReleaseMT/bin/blastn c++/ReleaseMT/bin/blastx c++/ReleaseMT/bin/datatool c++/ReleaseMT/bin/dustmasker c++/ReleaseMT/bin/legacy_blast.pl c++/ReleaseMT/bin/makemc++/ReleaseMT/bindex c++/ReleaseMT/bin/project_tree_builder c++/ReleaseMT/bin/rpsblast c++/ReleaseMT/bin/segmasker c++/ReleaseMT/bin/seqdb_perf c++/ReleaseMT/bin/tblastx c++/ReleaseMT/bin/update_blastdb.pl c++/ReleaseMT/bin/windowmasker_2.2.22_adapter.py)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $TB_DIR/$tb_name $STAGE_DIR/$seed_name
  cd $STAGE_DIR/$seed_name/c++
  configure_tool $seed_name "--without-debug --with-strip --with-mt --with-build-root=ReleaseMT"
  cd ReleaseMT/build
  make all_r
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
