#! /usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

inputs:
  fastq_file: File
  adapter_clip: File
  bowtie2_ref_1: File
  bowtie2_ref_2: File
  bowtie2_ref_3: File
  bowtie2_ref_4: File
  bowtie2_ref_rev_1: File
  bowtie2_ref_rev_2: File
  reference_genome: File
  reference_genome_index: File 
  reference_genome_fai: File 
  reference_genome_amb: File 
  reference_genome_ann: File 
  reference_genome_bwt: File 
  reference_genome_pac: File 
  reference_genome_sa: File 
  bed_file: File
  strand_bias_script: File
  var2vcf_script: File
  blacklist_bed_file: File
  


outputs:
# FASTQC_outputs
  fastqc_html_report:
    type: File
    outputSource: fastqc_report/fastq_html_file
  fastqc_zip_file:
    type: File
    outputSource: fastqc_report/fastq_zip_file
  fastqc_std_out:
    type: File
    outputSource: fastqc_report/log_file_stdout
  fastqc_std_err:
    type: File
    outputSource: fastqc_report/log_file_stderr

# Trimmomatic_outputs
  trimmomatic_fastq_q_filter_file:
    type: File
    outputSource: trim_adapters/fastq_q_filter_file
  trimmomatic_log_file_stdout:
    type: File
    outputSource: trim_adapters/log_file_stdout
  trimmomatic_log_file_stderr:
    type: File
    outputSource: trim_adapters/log_file_stderr

#bowtie2
  bowtie2_sam_file:
    type: File
    outputSource: align/aligned_sam
  bowtie2_log_file_std_out:
    type: File
    outputSource: align/log_file_stdout
  bowtie2_log_file_std_err:
    type: File
    outputSource: align/log_file_stderr  

# samtools_sort
  samtools_sort_sorted_bam:
    type: File
    outputSource: sort/sorted_bam
  samtools_sort_log_file_std_out:
    type: File
    outputSource: sort/log_file_stdout
  samtools_sort_log_file_std_err:
    type: File
    outputSource: sort/log_file_stderr

# samtools_index
  samtools_index_indexed_bam:
    type: File
    outputSource: index/indexed_bam
  samtools_index_log_file_std_out:
    type: File
    outputSource: index/log_file_stdout
  samtools_index_log_file_std_err:
    type: File
    outputSource: index/log_file_stderr

# vardict
  vardict_vcf_file:
    type: File
    outputSource: variant_calling/vcf_file
  vardict_log_file_std_out:
    type: File
    outputSource: variant_calling/log_file_stdout
  vardict_log_file_std_err:
    type: File
    outputSource: variant_calling/log_file_stderr

# Removing blacklisted regions 
  vcf_file_blacklist_removed:
    type: File
    outputSource: remove_blacklisted_regions/vcf_file_blacklist_removed
  bedtools_std_out:
    type: File
    outputSource: remove_blacklisted_regions/log_file_stdout
  bedtools_std_err:
    type: File
    outputSource: remove_blacklisted_regions/log_file_stderr


# normalize with VT
  normalized_vcf:
    type: File
    outputSource: normalize_vcf/normalized_vcf
  vt_std_out:
    type: File
    outputSource: normalize_vcf/log_file_stdout
  vt_std_err:
    type: File
    outputSource: normalize_vcf/log_file_stderr


steps:
  fastqc_report:
    run: fastqc.cwl
    in:
      fastq_file:
        source: fastq_file
    out: [fastq_html_file, fastq_zip_file, log_file_stdout, log_file_stderr]

  trim_adapters:
    run: trimmomatic_SE.cwl
    in:
      fastq_file:
        source: fastq_file
      adapter_clip:
        source: adapter_clip
    out: [fastq_q_filter_file, log_file_stdout, log_file_stderr]

  align:
    run: bowtie2.cwl
    in:
       bowtie2_ref_1:
         source: bowtie2_ref_1
       bowtie2_ref_2:
         source: bowtie2_ref_2
       bowtie2_ref_3:
         source: bowtie2_ref_3
       bowtie2_ref_4:
         source: bowtie2_ref_4
       bowtie2_ref_rev_1:
         source: bowtie2_ref_rev_1
       bowtie2_ref_rev_2:
         source: bowtie2_ref_rev_2
       fastq_file:
         source: trim_adapters/fastq_q_filter_file
    out: [aligned_sam, log_file_stdout, log_file_stderr]

  sort:
    run: samtools_sort.cwl
    in:
      sam_file:
        source: align/aligned_sam
    out: [sorted_bam, log_file_stdout, log_file_stderr]

  index: 
    run: samtools_index.cwl
    in:
      sorted_bam_file:
        source: sort/sorted_bam
    out: [indexed_bam, log_file_stdout, log_file_stderr]

  variant_calling:
    run: vardict.cwl
    in:
      reference_genome:
        source: reference_genome
      reference_genome_index:
        source: reference_genome_index
      reference_genome_fai:
        source: reference_genome_fai
      reference_genome_amb:
        source: reference_genome_amb
      reference_genome_ann:
        source: reference_genome_ann
      reference_genome_bwt:
        source: reference_genome_bwt
      reference_genome_pac:
        source: reference_genome_pac
      reference_genome_sa:
        source: reference_genome_sa
      sorted_bam_file:
        source: sort/sorted_bam
      indexed_bam_file:
        source: index/indexed_bam
      bed_file:
        source: bed_file
      strand_bias_script:
        source: strand_bias_script      
      var2vcf_script:
        source: var2vcf_script
    out: [vcf_file, log_file_stdout,log_file_stderr]

  remove_blacklisted_regions:
    run: remove_blacklist.cwl
    in:
      input_vcf:
        source: variant_calling/vcf_file
      blacklist_bed_file:
        source: blacklist_bed_file
    out: [vcf_file_blacklist_removed, log_file_stdout, log_file_stderr] 

  normalize_vcf:
    run: vt.cwl
    in:
      vcf_blacklist_removed:
        source: remove_blacklisted_regions/vcf_file_blacklist_removed
      reference_genome:
        source: reference_genome
      reference_genome_index:
        source: reference_genome_index
      reference_genome_fai:
        source: reference_genome_fai
      reference_genome_amb:
        source: reference_genome_amb
      reference_genome_ann:
        source: reference_genome_ann
      reference_genome_bwt:
        source: reference_genome_bwt
      reference_genome_pac:
        source: reference_genome_pac
      reference_genome_sa:
        source: reference_genome_sa    
    out: [normalized_vcf, log_file_stdout, log_file_stderr]