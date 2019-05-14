#! /usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

inputs: 
  fastq_forward: File
  fastq_reverse: File
  adapter_clip: File
  reference_genome_fasta: File 
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

# FASTQC outputs 

  fastqc_forward_html_report:
    type: File
    outputSource: fastqc_report/forward_html_file
  fastqc_reverse_html_report:
    type: File
    outputSource: fastqc_report/reverse_html_file
  fastqc_forward_zip_file:
    type: File
    outputSource: fastqc_report/forward_zip_file
  fastqc_reverse_zip_file:
    type: File
    outputSource: fastqc_report/reverse_zip_file
  fastqc_std_out:
    type: File
    outputSource: fastqc_report/log_file_stdout
  fastqc_std_err:
    type: File
    outputSource: fastqc_report/log_file_stderr

# Trimmomatic outputs 

  trimmomatic_forward_unpaired:
    type: File
    outputSource: trim_adapters/forward_u_filter_file
  trimmomatic_forward_q_filter:
    type: File
    outputSource: trim_adapters/forward_q_filter_file
  trimmomatic_reverse_unpaired:
    type: File
    outputSource: trim_adapters/reverse_u_filter_file
  trimmomatic_reverse_q_filter:
    outputSource: trim_adapters/reverse_q_filter_file
    type: File
  trimmomaitc_std_out:
    type: File
    outputSource: trim_adapters/log_file_stdout
  trimmomatic_std_err:
    type: File
    outputSource: trim_adapters/log_file_stderr

# Bowtie2 outputs 

  bowtie2_aligned_bam_file:
    type: File
    outputSource: align/aligned_bam
  bowtie2_std_out:
    type: File
    outputSource: align/log_file_stdout
  bowtie2_srd_err:
    type: File
    outputSource: align/log_file_stderr


# sam_sort 
  sam_sort_bam_file:
    type: File
    outputSource: sort/sorted_bam
  sam_sort_std_out:
    type: File
    outputSource: sort/log_file_stdout
  sam_sort_std_err:
    type: File
    outputSource: sort/log_file_stderr

# sam_index 
  sam_index_bam_file:
    type: File
    outputSource: index/indexed_bam
  sam_index_std_out:
    type: File
    outputSource: index/log_file_stdout
  sam_index_std_err:
    type: File
    outputSource: index/log_file_stderr


# variant calling (vardict) 
  vardict_vcf_file:
    type: File
    outputSource: variant_calling/vcf_file
  vardict_std_out:
    type: File
    outputSource: variant_calling/log_file_stdout
  vardict_std_err:
    type: File
    outputSource: variant_calling/log_file_stderr

# Remove blacklisted regions 
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
      fastq_forward:
        source: fastq_forward
      fastq_reverse:
        source: fastq_reverse
    out: [forward_html_file, reverse_html_file, forward_zip_file, reverse_zip_file, log_file_stdout, log_file_stderr]
  trim_adapters:
    run: trimmomatic_PE.cwl
    in:
      fastq_forward:
        source: fastq_forward
      fastq_reverse:
        source: fastq_reverse
      adapter_clip:
        source: adapter_clip
    out: [forward_u_filter_file, forward_q_filter_file, reverse_u_filter_file, reverse_q_filter_file, log_file_stdout, log_file_stderr]
  align:
    run: bowtie2.cwl
    in:
      bowtie_reference:
        source: reference_genome_fasta
      forward:
        source: trim_adapters/forward_q_filter_file
      reverse:
        source: trim_adapters/reverse_q_filter_file
    out: [aligned_bam, log_file_stdout, log_file_stderr]
  sort:
    run: samtools_sort.cwl
    in:
      bam_file:
        source: align/aligned_bam
    out: [sorted_bam, log_file_stdout, log_file_stderr]
  index:
    run: samtools_index.cwl
    in:
      sorted_bam:
        source: sort/sorted_bam
    out: [indexed_bam, log_file_stdout, log_file_stderr]
  variant_calling:
    run: vardict.cwl
    in:
      bwa_reference:
        source: reference_genome_fasta
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
      bam_file:
        source: sort/sorted_bam
      indexed_bam_file:
        source: index/indexed_bam
      bed_file:
        source: bed_file
      strand_bias_script:
        source: strand_bias_script
      var2vcf_script:
        source: var2vcf_script
    out: [vcf_file, log_file_stdout, log_file_stderr]
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
      reference_genome_fasta:
        source: reference_genome_fasta
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