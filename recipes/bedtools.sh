local version="2.15.0"
local type="tar.gz"
local URL="http://bedtools.googlecode.com/files/BEDTools.v${version}.${type}"
local tb_file=`basename $URL`
local seed_name="BEDTools-Version-${version}"
local install_files=(bin/coverageBed bin/slopBed bin/linksBed 
bin/mergeBed bin/bed12ToBed6 bin/closestBed bin/complementBed 
bin/overlap bin/annotateBed bin/subtractBed bin/maskFastaFromBed 
bin/windowBed bin/sortBed bin/unionBedGraphs bin/genomeCoverageBed 
bin/pairToPair bin/fastaFromBed bin/bedToBam bin/pairToBed 
bin/flankBed bin/bedToIgv bin/intersectBed bin/shuffleBed 
bin/fjoin bin/cuffToTrans bin/bamToBed bin/multiIntersectBed 
bin/multiBamCov bin/tabBam bin/nucBed bin/tagBam bin/nuclBed bin/groupBy)

do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  cd $seed_name
  make_tool $seed_name $make_j
  cd ..
  mv $seed_name $STAGE_DIR
  cp -r $STAGE_DIR/$seed_name ../BEDtools
}

do_activate()
{
  link_from_stage $seed_name ${install_files[@]}
}

do_remove()
{
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
}

source "$MAIN_DIR/lib/case.sh"
