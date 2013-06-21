local version="3.0.1"
local bigversion=${version:0:1}
local URL="http://www.cran.r-project.org/src/base/R-$bigversion/R-$version.tar.gz"
local tb_file=`basename $URL`
local type="tar.gz"
local seed_name=$(extract_tool_name $tb_file $type)
local install_files=(bin/R bin/Rscript)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  cd $seed_name
  configure_tool $seed_name "--enable-R-shlib --enable-memory-profiling --enable-static --enable-shared --with-tcltk"
  make_tool $seed_name $make_j
  install_tool $seed_name
  ($STAGE_DIR/$seed_name/bin/R --vanilla < $RESOURCES_DIR/r/r_new-packages.R > $LOG_DIR/${seed_name}.r_new-packages.Rout 2>&1) | tee $LOG_DIR/${seed_name}.r_new-packages.err
}

do_activate()
{
  link_from_stage $seed_name ${install_files[@]}
}

do_test()
{
  log "test"
}

do_remove()
{
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
}

source "$MAIN_DIR/lib/case.sh"
