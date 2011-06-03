bb_fake()
{
  local recipe=$1
  local bb_action="fake"
  log "Faking recipe: $recipe"
  check_recipe ${recipe}.sh
  log "recipe script found"
  source "$RECIPE_DIR/${recipe}.sh"
}

fake_install()
{
  local recipe_name=$1
  # assuming we have already loaded install
  # TODO: is there a way to load this again?
  before_install $recipe_name
  after_install $recipe_name
  local fake_flag="$LOG_DIR/$recipe_name.fake"
  log "touching fake flag [$fake_flag]"
  touch $fake_flag
}


check_if_fake()
{
  local fake_seed_name=$1
  [ -f $LOG_DIR/$fake_seed_name.fake ] && echo 1 || echo 0
}
