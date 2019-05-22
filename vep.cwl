#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  InitialWorkDirRequirement:
    listing:
    - $(inputs.vcf_normalized)
    - $(inputs.vep_dir)
  InlineJavascriptRequirement: {}

#hints:
  #DockerRequirement:
    #dockerImageId: ensemblorg/ensembl-vep:release_93.6

baseCommand: [/home/degan/Documents/pipeline_tools/ensembl-vep/vep]

inputs:
  vcf_normalized:
    type: File
    inputBinding:
      position: 1
      prefix: '-i'
      separate: True
  cache_flag:
    type: string
    default: '--cache'
    inputBinding:
      position: 3
  vep_dir:
    type: Directory 
    inputBinding:
      position: 4
      prefix: '--dir_cache'
      separate: True
      valueFrom: $(self.path)
  offline_flag:
    type: string
    default: '--offline'
    inputBinding:
      position: 5
  fork_flag:
    type: string
    default: '8'
    inputBinding:
      position: 1
      prefix: '--fork'
      separate: True
  symbol_flag:
    type: string
    default: '--symbol'
    inputBinding:
      position: 7
  biotype_flag:
    type: string
    default: '--biotype'
    inputBinding:
      position: 8
  exon_or_intron_flag:
    type: string
    default: '--numbers'
    inputBinding:
      position: 9
  sift_flag:
    type: string
    default: 'b'
    inputBinding:
      position: 10
      prefix: '--sift'
      separate: True
  polyphen_flag:
    type: string
    default: 'b'
    inputBinding:
      position: 10
      prefix: '--polyphen'
      separate: True
  clin_sig_flag:
    type: string
    default: '--check_existing'
    inputBinding:
      position: 12
  pubmed_flag:
    type: string
    default: '--pubmed'
    inputBinding:
      position: 14
  regulatory_flag:
    type: string
    default: '--regulatory'
    inputBinding:
      position: 15

arguments:
  - valueFrom: $(inputs.vcf_normalized.basename.split('.normalized')[0]+'.vep.vcf')
    position: 2
    prefix: '-o'
    separate: True

outputs:
  annotated_vcf:
    type: File
    outputBinding:
      glob: $(inputs.vcf_normalized.basename.split('.normalized')[0]+'.vep.vcf')
  html_file:
    type: File?
    outputBinding:
      glob: $(inputs.vcf_normalized.basename.split('.normalized')[0]+'.vep.vcf_summary.html')
  log_file_stdout:
    type: stdout
  log_file_stderr:
    type: stderr
stdout: vep_stdout.txt
stderr: vep_stderr.txt