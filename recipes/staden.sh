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
local version="2.0.0b9"

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
local URL="http://sourceforge.net/projects/staden/files/staden/${version}/staden-${version}-src.${type}"


#-------------------
# tb_file
# - Some helper functions currently require the base name of 
#   the tool being installed. This name should be stored 
#   in the tb_file variable. Usually, the basename function
#   can be used to derive this name, as shown below.
#-------------------
local tb_file=`basename $URL`
# staden-2.0.0b9.src

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
local seed_name="staden-${version}-src"
# staden-2.0.0b9-src

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
#local install_files=(samtools misc/samtools.pl bcftools/bcftools bcftools/vcfutils.pl)
local install_files=(alfsplit bin/copy_db bin/copy_reads bin/create_emboss_files bin/eba bin/find_renz bin/gap4 bin/gap5 bin/gap5_check bin/gap5_consensus bin/gap5_export bin/getABIcomment bin/getABIdate bin/getABIfield bin/getABISampleName bin/get_scf_field bin/hetins bin/init_exp bin/make_weights bin/mutscan bin/polyA_clip bin/prefinish bin/pregap4 bin/qclip bin/screen_seq bin/spin bin/staden_convert bin/stash bin/stops bin/tg_index bin/tg_index.bin bin/tg_view bin/tg_view.bin bin/tracediff bin/trev bin/vector_clip)


#-------------------
# deps
# - If you know this tool depends on another recipe being installed, 
#   then list it in $deps. This variable is automatically checked
#   during the installation process
#-------------------
local deps=("io_lib")


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
  mv $seed_name $STAGE_DIR
  cd $STAGE_DIR/$seed_name
  configure_tool $seed_name $configure_prefixes
  make_tool $seed_name $make_j
  install_tool $seed_name
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
	log "Started activate"
	log $STAGE_DIR/$seed_name
	cd $STAGE_DIR/$seed_name
	link_library bin/$seed_name
	link_from_stage $seed_name bin/${install_files[@]}
	log "Finished activate"
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
