
## see: http://etutorials.org/Misc/blast/Part+IV+Industrial-Strength+BLAST/Chapter+10.+Installation+and+Command-Line+Tutorial/10.2+WU-BLAST+Installation/

local tb_file="blast2.linux24-x64.tar.gz"
local type="tar.gz"
local seed_name=$(extract_tool_name $tb_file $type)
local install_files=(blasta,blastn,blastp,blastx,tblastn,tblastx,xdformat,xdget,nrdb,patdb,setdb,pressdb,wu-blastall,wu-formatdb)

do_install()
{
  cd $TB_DIR
  cp /n/local/stage/wublast/2005-03-22/blast2.linux24-x64.tar.gz .
  decompress_tool $tb_file $type
  cd $seed_name
  configure_tool $seed_name ""
  make_tool $seed_name $make_j
  install_tool $seed_name
  link_from_stage $seed_name ${install_files[@]}
}

do_remove()
{
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
}

source "$MAIN_DIR/lib/case.sh"
