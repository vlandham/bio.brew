
### 2.0.7 IN PROGRESS - APA

local version="2.1.1"
local type="tar.gz"
# sourceforge mirror was found by copying download link in 
# Firefox's download manager.
#local URL="http://sourceforge.net/projects/samtools/files/samtools/${version}/samtools-${version}.${type}/download"
#local URL="http://www.tbi.univie.ac.at/~ivo/RNA/ViennaRNA-${version}.${type}"  # old URL for 1.8.5
local URL="http://www.tbi.univie.ac.at/~ronny/RNA/ViennaRNA-$version.$type"  # new URL for 2.0.7

local tb_file=`basename $URL`
local seed_name="ViennaRNA-${version}"

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR
  cd $STAGE_DIR/$seed_name
  mkdir -p install
#  configure_tool $seed_name "" "$STAGE_DIR/$seed_name/install"   # 1.8.5
  configure_tool $seed_name "--with-forester --with-cluster --datadir=$STAGE_DIR/$seed_name/install" "$STAGE_DIR/$seed_name/install"
  make_tool $seed_name $make_j 
  install_tool $seed_name

  # for some reason the '--with-forester' flag isn't working. 
  # so lets build that part manually
  cd $STAGE_DIR/$seed_name/RNAforester
  ./configure --prefix "${STAGE_DIR}/${seed_name}/install"
  make
  make install
}

do_activate()
{
  switch_current $seed_name
  link_bin $seed_name 'install/bin'
  link_bin $seed_name 'install/ViennaRNA/bin'
  link_library $seed_name 'install/lib'
  link_include $seed_name 'install/include'
  link_share $seed_name 'install/share'

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
