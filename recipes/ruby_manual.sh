local version="1.9.3-p125"
local type="tar.gz"
local URL="http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-${version}.${type}"
local tb_file=`basename $URL`
local seed_name="ruby-${version}"
local install_files=(bin/ruby bin/irb bin/gem bin/ri bin/rake bin/erb bin/rdoc)
local deps=(libyaml)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $seed_name $STAGE_DIR
  cd $STAGE_DIR/$seed_name
  configure_tool $seed_name "--enable-shared --disable-install-doc --with-opt-dir=${BB_INSTALL}"
  make_tool $seed_name $make_j
  install_tool $seed_name
}

do_activate()
{
  link_from_stage $seed_name ${install_files[@]}
  link_library $seed_name
  link_include $seed_name
  link_share $seed_name

  # for_env "export PATH=\"$STAGE_DIR/current/bin:\$PATH\""
}

do_remove()
{
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
}

source "$MAIN_DIR/lib/case.sh"
