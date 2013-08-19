local version="1.96"
local type="zip"
local tb_file="picard-tools-${version}.${type}"
local URL="http://sourceforge.net/projects/picard/files/picard-tools/${version}/${tb_file}"
local tb_dir=`basename $tb_file .$type`
local seed_name="picard_${version}"
local deps=(java)
local install_files=(AddOrReplaceReadGroups.jar BamIndexStats.jar BamToBfq.jar BuildBamIndex.jar CalculateHsMetrics.jar CheckIlluminaDirectory.jar CleanSam.jar CollectAlignmentSummaryMetrics.jar CollectGcBiasMetrics.jar CollectInsertSizeMetrics.jar CollectMultipleMetrics.jar CollectRnaSeqMetrics.jar CollectTargetedPcrMetrics.jar CompareSAMs.jar CreateSequenceDictionary.jar DownsampleSam.jar EstimateLibraryComplexity.jar ExtractIlluminaBarcodes.jar ExtractSequences.jar FastqToSam.jar FilterSamReads.jar FixMateInformation.jar IlluminaBasecallsToSam.jar IlluminaBasecallsToFastq.jar IntervalListTools.jar MarkDuplicates.jar MeanQualityByCycle.jar MergeBamAlignment.jar MergeSamFiles.jar MergeVcfs.jar NormalizeFasta.jar QualityScoreDistribution.jar ReorderSam.jar ReplaceSamHeader.jar RevertSam.jar SamFormatConverter.jar SamToFastq.jar SortSam.jar SplitVcfs.jar ValidateSamFile.jar VcfFormatConverter.jar ViewSam.jar)


do_install()
{
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  mv $tb_dir $seed_name
  mv $seed_name $STAGE_DIR
}

do_activate()
{
  link_from_stage $seed_name ${install_files[@]}
  for_env "export PICARD='$STAGE_DIR/current'"
}

do_test()
{
  cd $STAGE_DIR
  java -jar $STAGE_DIR/$seed_name/CollectAlignmentSummaryMetrics.jar REFERENCE_SEQUENCE=/n/data1/genomes/igenome/Mus_musculus/UCSC/mm9/Sequence/BWAIndex/genome.fa INPUT=$BB_PATH/tests/sample.bam OUTPUT=/tmp/picard.$seed_name.txt VALIDATION_STRINGENCY=SILENT
  rm /tmp/picard*
}

do_remove()
{
  remove_recipe $seed_name
}

source "$MAIN_DIR/lib/case.sh"
