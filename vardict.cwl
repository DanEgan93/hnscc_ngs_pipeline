#!/usr/bin/env cwl-runner

# TODO check that the BED file starts from 0
# The current default is -z:1 i.e. the BED starts from 0
cwlVersion: v1.0
class: CommandLineTool

requirements:
  # checks for the presents of files in the output(working) directory
  InitialWorkDirRequirement:
    listing:
     - $(inputs.reference_genome)  
     - $(inputs.sorted_bam_file)
     - $(inputs.indexed_bam_file)
     - $(inputs.bed_file)
     - $(inputs.strand_bias_script)
     - $(inputs.reference_genome_index)
     - $(inputs.reference_genome_fai)
     - $(inputs.reference_genome_amb)
     - $(inputs.reference_genome_ann)
     - $(inputs.reference_genome_bwt)
     - $(inputs.reference_genome_pac)
     - $(inputs.reference_genome_sa)  
     - $(inputs.var2vcf_script) 

  InlineJavascriptRequirement: {}
  ShellCommandRequirement:
    class: string

hints:
  DockerRequirement:
    dockerImageId: vardict:latest

baseCommand: [java, -jar, /usr/local/pipeline/VarDict/VarDictJava/build/libs/VarDict-1.6.0.jar]

inputs:
  reference_genome:
    type: File
    inputBinding:
      position: 1
      prefix: -G
      separate: True

  allele_freq:
    type: double
    default: 0.01
    inputBinding:
      position: 2
      prefix: -f
      separate: True
  sample_name:
    type: string
    default: 'sample_name'
    inputBinding:
      valueFrom: $(inputs.sorted_bam_file.nameroot.split(".sorted.")[0]+'.vcf')
      position: 3
      prefix: -N
      separate: True
  sorted_bam_file:
    type: File
    inputBinding:
      valueFrom: $(self.basename)
      position: 4
      prefix: -b
      separate: True

  bed_start_pos:
    type: int
    default: 1
    inputBinding:
      position: 5
      prefix: -z
      separate: True
  chromosome_name:
    type: int
    default: 1 
    inputBinding:
      position: 6
      prefix: -c
      separate: True
  region_start:
    type: int
    default: 2
    inputBinding:
      position: 7
      prefix: -S
      separate: True
  region_end:
    type: int
    default: 3
    inputBinding:
      position: 8
      prefix: -E
      separate: True
  segment_name:
    type: int
    default: 4
    inputBinding:
      position: 9
      prefix: -g
      separate: True
  bed_file:
    type: File
    inputBinding:
      position: 10
  pipe_to_strand_bias:
    type: string
    default: '|'
    inputBinding:
      shellQuote: false
      position: 11
  strand_bias_script:
    type: File
    inputBinding: 
      valueFrom: $(self.path)
      position: 12
  pipe_to_var2_valid:
    type: string
    default: '|'
    inputBinding:
      shellQuote: false
      position: 13
  var2vcf_script:
    type: File
    inputBinding: 
      valueFrom: $(self.path)
      position: 14
  redirect:
    type: string
    default: '>'
    inputBinding:
      shellQuote: false
      position: 15


  # secondary files
  indexed_bam_file:
    type: File
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


arguments:
  - valueFrom: $(inputs.sorted_bam_file.nameroot.split(".sorted.bam")[0]+'.vcf')
    position: 16

outputs:
  vcf_file:
    type: File
    outputBinding: 
      glob: $(inputs.sorted_bam_file.nameroot.split(".sorted.bam")[0]+'.vcf')
  log_file_stdout:
    type: stdout
  log_file_stderr:
    type: stderr

stdout: vardict_stdout.txt
stderr: vardict_stderr.txt