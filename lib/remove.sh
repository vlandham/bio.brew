bb_remove()
{
  local recipe=$1
  local bb_action="remove"
  check_recipe ${recipe}.sh
  log "recipe script found"
  source "$RECIPE_DIR/${recipe}.sh"
}

before_remove()
{
  local recipe_name=$1
  [ -f $LOG_DIR/$recipe_name.lock ] && usage 1 "Other instance is working on $recipe_name. Bailing out."
  touch $LOG_DIR/$recipe_name.lock
}

remove_recipe()
{
  local recipe_name=$1
  log "removing: $TB_DIR/$recipe_name"
  rm -rf $TB_DIR/$recipe_name
  log "removing: $STAGE_DIR/$recipe_name"
  rm -rf $STAGE_DIR/$recipe_name
  log "removing: $LOG_DIR/$recipe.env.sh"
  rm -rf "$LOG_DIR/$recipe.env.sh"
  log "removing current link."
  log "NOTE: reset current link for this recipe to previous seed manually"
  rm -rf $STAGE_DIR/current
}

remove_recipe_using_make()
{
  local recipe_name=$1
  local log_file=$LOG_DIR/${recipe_name}.uninstall.log.txt
  log "removing using make. log: ${log_file}"
  cd $STAGE_DIR/$recipe_name
  make uninstall &> $log_file
  cd -
}

remove_from_stage()
{
  local recipe_name=$1; shift
  local install_files=("$@")
  if [ $(check_if_active $recipe_name) == "1" ]
  then
    deactivate_recipe $recipe_name
    for f in ${install_files[@]} 
    do
      local bn=`basename $f`
      log "removing link from from staging area [$f]"
      rm -f $LOCAL_DIR/bin/$bn
    done
  else
    log "recipe not active. skipping remove from stage"
  fi
}

after_remove()
{
  local recipe_name=$1
  local lock_file="$LOG_DIR/$recipe_name.lock"
  local install_flag="$LOG_DIR/$recipe_name.installed"
 
  log "removing lock. [$lock_file]"
  rm -f $lock_file
  log "removing install flag [$install_flag]"
  rm -f $install_flag
  log "recipe [$recipe_name] removed."
}

