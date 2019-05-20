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
  cache_cmd:
    type: string
    default: '--cache'
    inputBinding:
      position: 3
  offline_cmd:
    type: string
    default: '--offline'
    inputBinding:
      position: 5
  vep_dir:
    type: Directory 
    inputBinding:
      position: 4
      prefix: '--dir_cache'
      separate: True
      valueFrom: $(self.path)

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
    type: File
    outputBinding:
      glob: $(inputs.vcf_normalized.basename.split('.normalized')[0]+'.vep.vcf_summary.html')
  warning_file:
    type: File
    outputBinding:
      glob: $(inputs.vcf_normalized.basename.split('.normalized')[0]+'.vep.vcf_warnings.txt')
  log_file_stdout:
    type: stdout
  log_file_stderr:
    type: stderr
stdout: vep_stdout.txt
stderr: vep_stderr.txt