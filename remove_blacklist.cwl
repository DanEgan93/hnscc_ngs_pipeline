#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  InitialWorkDirRequirement:
    listing:
     - $(inputs.input_vcf)
     - $(inputs.blacklist_bed_file)
  InlineJavascriptRequirement: {}
  ShellCommandRequirement:
    class: string

hints:
  DockerRequirement:
    dockerImageId: bed_intersect:latest

baseCommand: [intersectBed]

inputs:
  v_flag: 
    type: string
    default: '-v'
    inputBinding: 
      position: 1
  header_flag:
    type: string
    default: '-header'
    inputBinding:
      position: 2
  input_vcf:
    type: File
    inputBinding:
      position: 3
      prefix: '-a'
      separate: True
  blacklist_bed_file:
    type: File
    inputBinding:
      position: 4
      prefix: '-b'
      separate: True
  redirect:
    type: string
    default: '>'
    inputBinding:
      shellQuote: false
      position: 5

arguments:
  - valueFrom: $(inputs.input_vcf.nameroot+'.blacklist_removed.vcf')
    position: 6

outputs:
  vcf_file_blacklist_removed:
    type: File
    outputBinding:
      glob: $(inputs.input_vcf.nameroot+'.blacklist_removed.vcf')
  log_file_stdout:
    type: stdout
  log_file_stderr:
    type: stderr
stdout: fastqc_stdout.txt
stderr: fastqc_stderr.txt