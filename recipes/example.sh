# bio.brew recipes are a combination of 3 things:
# * consistently named variables
# * install/activate/remove functions
# * regular shell script commands

# Typically, the first step is to define some local variables that will be used
# in the rest of the script, and in the bio.brew helper functions to facilitate 
# installing and managing a tool. 
# The names of these variables come from a limited vocabulary. Don't deviate from
# this vocabulary or it could result in an unfunctioning recipe.

#-------------------
# REQUIRED VARIABLES
#-------------------

#-------------------
# version
#  - a string representation of the version of the tool that this
#    recipe installs. Typically this is the most frequently changed
#    component of a recipe, so put it on top.
#-------------------
local version="1.2.3"

#-------------------
# type
# - The type of file that will be downloaded when installing this
#   tool. For recipes that do not have file types (like a git repo)
#   this variable is not required. 
# - Note that it does not start with a '.'
#-------------------
local type="tar.gz"


#-------------------
# URL
# - The full path of the location of the download archive. 
# - Note the use of previously declared variables in the 
#   string.
#-------------------
local URL="http://sourc3.net/project/tool/tool-${version}.${type}"


#-------------------
# tb_file
# - Some helper functions currently require the base name of 
#   the tool being installed. This name should be stored 
#   in the tb_file variable. Usually, the basename function
#   can be used to derive this name, as shown below.
#-------------------
local tb_file=`basename $URL`


#-------------------
# seed_name
# - The seed_name is an important variable in bio.brew. 
#   It should contain both the tools name as well as the
#   current version of the tool being installed. 
# - This variable is used when creating paths to allow for
#   multiple versions of the same tool to not over-write themselves
# - Make sure to use the $version variable so you don't have to repeat
#   yourself!
#-------------------
local seed_name="tool-${version}"


#-------------------
# OPTIONAL VARIABLES
#-------------------

#-------------------
# install_files
# - This is an array of all the compiled bin files that will be symlinked to
#   the bin directory, using the link_from_stage helper function. 
# - Technically, you can name this array anything, but lets keep things consistent
# - Note the strange syntax for bash arrays
#-------------------
local install_files=(samtools misc/samtools.pl bcftools/bcftools bcftools/vcfutils.pl)

#-------------------
# deps
# - If you know this tool depends on another recipe being installed, 
#   then list it in $deps. This variable is automatically checked
#   during the installation process
#-------------------
local deps=("java")


#-------------------
# RECIPE FUNCTIONS
#-------------------

# Once all your variables are in order, its time to write your
# Recipe's installation functions. There are 4 required functions:
# - do_install
# - do_activate
# - do_test
# - do_remove

# Inside each function, use your variables and helper functions 
# to reduce code duplication and energize synergy!

#-------------------
# do_install
# - Performs the following:
#   - move to correct location
#   - download archive file
#   - extract to correct location
#   - configure / build / make tool inside stage dir
#
# - Does NOT create symlinks for current or modify 
#   current symlinks. That is what do_activate is for
#-------------------
do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  cd $seed_name
  make_tool $seed_name $make_j
  cd ..
  mv $seed_name $STAGE_DIR
}

#-------------------
# do_activate
# - Performs symlinking to make this version
#   of the tool the default one.
# - Also, if custom env is created for this tool,
#   add it here
#-------------------
do_activate()
{
  for_env "export EXAMPLE_TOOL_ENV='$STAGE_DIR/$seed_name'"
  link_from_stage $seed_name ${install_files[@]}
}

#-------------------
# do_test
# - Optional test function. Would be useful to 
#   try stuff out - BEFORE activating. In practice,
#   not many recipes are using this yet.
#-------------------
do_test()
{
  log "test"
}


#-------------------
# do_remove
# - Undo what you did.
# - Typically this means:
# - Removing the recipe 
# - Removing stagged install files
# - clearing env
#-------------------
do_remove()
{
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
  clear_env
}

#-------------------
# IMPORTANT
# The last line of your recipe should
# source the lib/case.sh file
#-------------------
source "$MAIN_DIR/lib/case.sh"
