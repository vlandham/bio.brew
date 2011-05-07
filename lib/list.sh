bb_list()
{
  n_recipes=`ls $RECIPE_DIR/ | wc -l`

  if [ $n_recipes != "0" ]
  then
    for r in `ls $RECIPE_DIR/*.sh`
    do
      local recipe=`basename $r | sed "s/\.sh$//g"`
      local installed="-"
      local bb_action="list"
      local s_deps=""
      source "${r}"
      local full_name="$recipe/$seed_name"
      # get the dependency list
      for d in "${deps[@]}"; do s_deps="$s_deps $d"; done

      if [ $(check_any_installed $recipe) == "1" ] 
      then
        printf "%s : \n" "$recipe"
        local all_installed=$(find_all_installed $recipe)
        for installed_seed in $all_installed
        do
          full_name="$recipe/$installed_seed"
          [ $(check_if_active $full_name) == "1" ] && installed="A" || installed="I"
          printf "%s : %-24.24s : %s\n" "$installed" "$installed_seed" "$s_deps"
        done
      else
        printf "%s : %-24.24s : %s\n" "$installed" "$seed_name" "$s_deps"
      fi
      deps=""
    done
  else
    echo "No recipes found." 
  fi 
}
