#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  InitialWorkDirRequirement:
    listing:
     - $(inputs.reference_genome_fasta)
     - $(inputs.reference_genome_index)
     - $(inputs.reference_genome_fai)
     - $(inputs.reference_genome_amb)
     - $(inputs.reference_genome_ann)
     - $(inputs.reference_genome_bwt)
     - $(inputs.reference_genome_pac)
     - $(inputs.reference_genome_sa)          
     - $(inputs.forward_fastq_q_filter)
     - $(inputs.reverse_fastq_q_filter)

  InlineJavascriptRequirement: {}
  ShellCommandRequirement:
    class:

hints:
  DockerRequirement:
    dockerImageId: bwa:latest

baseCommand: [/usr/local/pipeline/bwa-0.7.16a/bwa, mem, -t1, -k19]

inputs:
  reference_genome_fasta:
    type: File
    inputBinding: 
      valueFrom: $(self.basename)
      position: 1

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
 
  forward_fastq_q_filter:
    type: File
    inputBinding: 
      valueFrom: $(self.basename)
      position: 2
  reverse_fastq_q_filter:
    type: File
    inputBinding: 
      valueFrom: $(self.basename)
      position: 3
  greater_than:
    type: string
    default: '>'
    inputBinding:
      shellQuote: false
      position: 4
arguments:
  - valueFrom: $(inputs.forward_fastq_q_filter.nameroot + '.bam')
    position: 5

outputs:
  aligned_bam:
    type: File
    outputBinding:
      glob: $(inputs.forward_fastq_q_filter.nameroot + '.bam')
  log_file_stdout:
    type: stdout
  log_file_stderr:
    type: stderr

stdout: bwa_stdout.txt
stderr: bwa_stderr.txt