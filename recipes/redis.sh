
local URL="http://github.com/antirez/redis.git"
local seed_name="redis"
local deps=()
local install_files=(src/redis-server src/redis-cli)

do_install()
{
  cd $LOCAL_DIR
  log "git cloning: $URL"
  git clone $URL &> $LOG_DIR/${seed_name}.git_clone.log.txt
  cd $seed_name
  log "make"
  make_tool $seed_name $make_j
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
