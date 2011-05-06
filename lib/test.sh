bb_test()
{
  local recipe=$1
  local bb_action="test"
  log "Testing recipe: $recipe"
  check_recipe ${recipe}.sh
  log "recipe script found"
  source "$RECIPE_DIR/${recipe}.sh"
}
