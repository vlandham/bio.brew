local version="26-Sep-2012"
## there is no other version in this directory

local URL="http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64"
## root directory from which they come

local recipeName=jimKentUtils
## chosen after examining:
## http://genome-source.cse.ucsc.edu/gitweb/?p=kent.git;a=blob_plain;hb=HEAD;f=src/makefile

local seed_name="${recipeName}-${version}"

#local install_files=(wigToBigWig  bigWigToWig)

do_install()
{
# !! which will be /n/local/stage - set by framework
 ## cd $TB_DIR
  mkdir -p ${STAGE_DIR}/${seed_name}
  cd  ${STAGE_DIR}/${seed_name}
  wget -nH -r --cut-dirs=5 -N -l inf ftp://hgdownload.cse.ucsc.edu/apache/htdocs/admin/exe/linux.x86_64/
  find . -regex '.*\(README\|FOOTER\|wget-log\).*' |  xargs rm
  ##find . -mindepth 1 -type f | xargs -I{}  mv {}  ${STAGE_DIR}/${seed_name}
  #wget ${install_files[@]/#/${URL}/}
  #mv ${install_files[@]} ${STAGE_DIR}/${seed_name}
}

do_activate()
{
  #for_env "export EXAMPLE_TOOL_ENV='$STAGE_DIR/$seed_name'"
  x=(`ls -1 ${STAGE_DIR}/${seed_name}`)
  link_from_stage $seed_name  ${x[@]}
}

do_test()
{
  log "test"
}

do_remove()
{
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
  #undo for_env with: 
   # clear_env
}

#g-------------------
# IMPORTANT
# The last line of your recipe should
# source the lib/case.sh file
#-------------------
source "$MAIN_DIR/lib/case.sh"
