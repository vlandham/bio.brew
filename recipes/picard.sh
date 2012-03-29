
local version="1.62"
local type="zip"
local tb_file="picard-tools-${version}.${type}"
local URL="http://sourceforge.net/projects/picard/files/picard-tools/${version}/${tb_file}"
local tb_dir=`basename $tb_file .$type`
local seed_name="picard_${version}"
local deps=(java)
local install_files=(AddOrReplaceReadGroups.jar CleanSam.jar CollectRnaSeqMetrics.jar ExtractIlluminaBarcodes.jar IlluminaBasecallsToSam.jar MergeSamFiles.jar ReplaceSamHeader.jar SortSam.jar BamIndexStats.jar CollectAlignmentSummaryMetrics.jar CompareSAMs.jar ExtractSequences.jar IntervalListTools.jar NormalizeFasta.jar RevertSam.jar ValidateSamFile.jar BamToBfq.jar CollectGcBiasMetrics.jar CreateSequenceDictionary.jar FastqToSam.jar MarkDuplicates.jar ViewSam.jar BuildBamIndex.jar CollectInsertSizeMetrics.jar DownsampleSam.jar FilterSamReads.jar MeanQualityByCycle.jar QualityScoreDistribution.jar SamFormatConverter.jar CalculateHsMetrics.jar CollectMultipleMetrics.jar EstimateLibraryComplexity.jar FixMateInformation.jar MergeBamAlignment.jar ReorderSam.jar SamToFastq.jar)

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
  java -jar $STAGE_DIR/$seed_name/CollectAlignmentSummaryMetrics.jar REFERENCE_SEQUENCE=/n/data1/genomes/igenome/Mus_musculus/UCSC/mm9/Sequence/BWAIndex/genome.fa INPUT=../../stowers.bio.brew/tests/sample.bam OUTPUT=../../stowers.bio.brew/tests/picard.txt VALIDATION_STRINGENCY=SILENT
}

do_remove()
{
  remove_recipe $seed_name
}

source "$MAIN_DIR/lib/case.sh"
