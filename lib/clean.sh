bb_clean()
{
  local recipe=$1
  local bb_action="clean"
  log "Cleaning recipe: $recipe"
  check_recipe ${recipe}.sh
  log "recipe script found"  
  source "$RECIPE_DIR/${recipe}.sh"
}

do_clean()
{
  local recipe_name=$1
  local lock_file="$LOG_DIR/$recipe_name.lock"
  local install_flag="$LOG_DIR/$recipe_name.installed"
  log "removing $lock_file"
  rm -f $lock_file
  log "removing $install_flag"
  rm -f $install_flag
  # remember - LOG_DIR is really log/recipe
  log "removing $LOG_DIR"
  rm -rf $LOG_DIR
  # same for STAGE_DIR
  log "removing $STAGE_DIR"
  rm -rf $STAGE_DIR
}
