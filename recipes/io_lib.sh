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
#local version="1.12.1"
#local version="1.12.2"
local version="1.12.5"

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
local URL="https://sourceforge.net/projects/staden/files/io_lib/${version}/io_lib-${version}.${type}"


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
local seed_name="io_lib-${version}"


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
local install_files=(bin/append_sff bin/convert_trace bin/extract_fastq bin/extract_qual bin/extract_seq bin/get_comment bin/hash_exp bin/hash_extract bin/hash_list bin/hash_sff bin/hash_tar bin/index_tar bin/io_lib-config bin/makeSCF bin/scf_dump bin/scf_info bin/scf_update bin/srf2fasta bin/srf2fastq bin/srf_dump_all bin/srf_extract_hash bin/srf_extract_linear bin/srf_filter bin/srf_index_hash bin/srf_info bin/srf_list bin/trace_dump bin/ztr_dump)

#-------------------
# deps
# - If you know this tool depends on another recipe being installed, 
#   then list it in $deps. This variable is automatically checked
#   during the installation process
#-------------------
#local deps=("java")


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
  log $TB_DIR
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  log $seed_name
  log $STAGE_DIR
  mv $seed_name $STAGE_DIR
  cd $STAGE_DIR/$seed_name
  configure_tool $seed_name 
  make_tool $seed_name $make_j
  install_tool $seed_name
  log "finished install"
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
  log "started activate"
  #for_env "export EXAMPLE_TOOL_ENV='$STAGE_DIR/$seed_name'"
  link_from_stage $seed_name ${install_files[@]}
  cd $STAGE_DIR/$seed_name
  link_library $seed_name 
  log "finished activate"
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
