local URL="ftp://ftp.vim.org/pub/vim/unix/vim-7.3.tar.bz2"
local tb_file=`basename $URL`
local type="tar.bz2"
local seed_name="vim73"
local install_files=(bin/vim bin/vimdiff bin/vimtutor)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  cd $seed_name
  configure_tool $seed_name
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
