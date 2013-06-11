local version="0.2.6"
local type="tar.bz2"
# sourceforge mirror was found by copying download link in 
# Firefox's download manager.


#http://downloads.sourceforge.net/project/samtools/tabix/tabix-0.2.6.tar.bz2?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fsamtools%2Ffiles%2Ftabix%2F&ts=1370973942&use_mirror=superb-dca3
#http://downloads.sourceforge.net/project/samtools/tabix/tabix-0.2.6.tar.bz2?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fsamtools%2Ffiles%2Ftabix%2F&ts=1370973942&use_mirror=superb-dca3

# warning - This link has changed a few times now...
local URL="http://sourceforge.net/projects/samtools/files/tabix/tabix-${version}.${type}"
local tb_file="tabix-${version}.${type}";
local seed_name="tabix-${version}"
local install_files=(tabix bgzip)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  cd $seed_name
  make_tool $seed_name $make_j
  cd ..
  mv $seed_name $STAGE_DIR
}

do_activate()
{
#  for_env "export SAMTOOLS_DIR='$STAGE_DIR/$seed_name'"
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
