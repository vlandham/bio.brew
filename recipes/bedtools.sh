local version="2.15.0"
local type="tar.gz"
local URL="http://bedtools.googlecode.com/files/BEDTools.v${version}.${type}"
local tb_file=`basename $URL`
local tar_name="BEDTools-Version-${version}"
local seed_name="bedtools-${version}"
local install_files=(bin/annotateBed
bin/bamToBed
bin/bed12ToBed6
bin/bedToBam
bin/bedToIgv
bin/bedpeToBam
bin/bedtools
bin/closestBed
bin/clusterBed
bin/complementBed
bin/coverageBed
bin/fastaFromBed
bin/flankBed
bin/genomeCoverageBed
bin/getOverlap
bin/groupBy
bin/intersectBed
bin/linksBed
bin/maskFastaFromBed
bin/mergeBed
bin/multiBamCov
bin/multiIntersectBed
bin/nucBed
bin/pairToBed
bin/pairToPair
bin/shuffleBed
bin/slopBed
bin/sortBed
bin/subtractBed
bin/tagBam
bin/unionBedGraphs
bin/windowBed
bin/windowMaker)


do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $tar_name $STAGE_DIR/$seed_name
  cd $STAGE_DIR/$seed_name
  make_tool $seed_name $make_j
  cd ..
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
