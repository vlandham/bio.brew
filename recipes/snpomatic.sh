local version="R14"
local type=""
local URL="https://snpomatic.svn.sourceforge.net/svnroot/snpomatic";
local tb_file=`basename $URL`
local seed_name="snpomatic_$version"
local install_files=(findknownsnps)

do_install()
{
  cd $TB_DIR
  mkdir $seed_name
  mv $seed_name $STAGE_DIR
  cd $STAGE_DIR/$seed_name
  wget -e robots=off -m $URL
  mv snpomatic.svn.sourceforge.net/svnroot/snpomatic/* .
  rm -Rf snpomatic.svn.sourceforge.net
  make_tool $seed_name $make_j
}

do_activate()
{
  link_from_stage $seed_name ${install_files[@]}
  switch_current $seed_name
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
