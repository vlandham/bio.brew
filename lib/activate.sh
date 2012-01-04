bb_activate()
{
  local recipe=$1
  local bb_action="activate"

  check_recipe ${recipe}.sh
  log "recipe script found"
  source "$RECIPE_DIR/${recipe}.sh"
}

before_activate()
{
  local seed_name=$1
  log "activating seed: $seed_name"
  log "deactivating other seeds"
  rm -f $LOG_DIR/*.active
}

after_activate()
{
  local seed_name=$1
  local activate_flag="$LOG_DIR/$seed_name.active"
  log "touching active flag [$activate_flag]"
  touch $activate_flag
}

check_if_active()
{
  local active_seed_name=$1
  [ -f $LOG_DIR/$active_seed_name.active ] && echo 1 || echo 0
}

switch_current()
{
  local seed_name=$1; shift

  #first ensure the current link is present
  # and pointing to the current seed_name dir
  rm -f $STAGE_DIR/current
  ln -s $STAGE_DIR/$seed_name $STAGE_DIR/current
}

link_from_stage()
{
  local seed_name=$1; shift
  local install_files=("$@")

  switch_current $seed_name

  for f in ${install_files[@]} 
  do
    local bn=`basename $f`
    log "linking from staging area [$f]"
    rm -f $LOCAL_DIR/bin/$bn
    ln -s $STAGE_DIR/current/$f $LOCAL_DIR/bin/$bn
    log "Setting permission"
    [ -f $STAGE_DIR/$seed_name/$f ] && chmod 755 $STAGE_DIR/$seed_name/$f
  done
  return 0
}

deactivate_recipe()
{
  local active_seed_name=$1;
  if [ $(check_if_active $active_seed_name) == "1" ]
  then
    rm -f $LOG_DIR/$active_seed_name.active
  else
    log "recipe seed not active [$active_seed_name]"
  fi
}

