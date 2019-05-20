#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  InitialWorkDirRequirement:
    listing:
     - $(inputs.vcf_blacklist_removed)
     - $(inputs.reference_genome)
     - $(inputs.reference_genome_index)
     - $(inputs.reference_genome_fai)
     - $(inputs.reference_genome_amb)
     - $(inputs.reference_genome_ann)
     - $(inputs.reference_genome_bwt)
     - $(inputs.reference_genome_pac)
     - $(inputs.reference_genome_sa)  
  InlineJavascriptRequirement: {}
  ShellCommandRequirement:
    class: string

hints:
  DockerRequirement:
    dockerImageId: vt:latest

baseCommand: [vt, decompose]

inputs:
  vcf_blacklist_removed:
    type: File
    inputBinding:
      position: 1
      prefix: '-s'
      separate: True
  pipe_to_normalize:
    type: string
    default: '|'
    inputBinding:
      shellQuote: false
      position: 2
  vt_command:
    type: string
    default: 'vt'
    inputBinding:
      position: 3
  vt_normalize_command:
    type: string
    default: 'normalize'
    inputBinding:
      position: 4
  m_flag:
    type: string
    default: '-m'
    inputBinding:
      position: 5
  r_flag:
    type: string
    default: '-r'
    inputBinding:
      position: 6
  reference_genome:
    type: File
    inputBinding:
      valueFrom: $(self.path)
      position: 7

  # secondary files
  reference_genome_index:
    type: File
  reference_genome_fai:
    type: File
  reference_genome_amb:
    type: File
  reference_genome_ann:
    type: File
  reference_genome_bwt:
    type: File
  reference_genome_pac: 
    type: File
  reference_genome_sa:
    type: File

  o_flag:
    type: string
    default: '-o'
    inputBinding:
      position: 8
arguments:
  - valueFrom: $(inputs.vcf_blacklist_removed.basename.split('.blacklist_removed.')[0]+'.normalized.vcf')
    position: 9
  - valueFrom: '-'
    position: 10

outputs:
  normalized_vcf:
    type: File 
    outputBinding:
      glob: $(inputs.vcf_blacklist_removed.basename.split('.blacklist_removed.')[0]+'.normalized.vcf')
  log_file_stdout:
    type: stdout
  log_file_stderr:
    type: stderr

stdout: vt_stdout.txt
stderr: vt_stderr.txt


# Variant normalization step
#/home/degan/Documents/pipeline_tools/vt/vt decompose -s sample.blacklist_removed.vcf 
#| /home/degan/Documents/pipeline_tools/vt/vt normalize -m -r /media/sf_S_DRIVE/genomic_resources/gatk_bundle/ucsc.hg19.fasta -o sample.normalised.vcf 