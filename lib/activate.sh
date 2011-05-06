bb_activate()
{
  local recipe=$1
  local bb_action="activate"
  log "Activating recipe: $recipe"
  check_recipe ${recipe}.sh
  log "recipe script found"
  source "$RECIPE_DIR/${recipe}.sh"
}

link_from_stage()
{
  local seed_name=$1; shift
  local install_files=("$@")

  #first ensure the current link is present
  # and pointing to the current seed_name dir
  rm -f $STAGE_DIR/current
  ln -s $STAGE_DIR/$seed_name $STAGE_DIR/current

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