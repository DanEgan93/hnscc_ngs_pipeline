#! usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  InitialWorkDirRequirement:
    listing:
     - $(inputs.input_file)
  InlineJavascriptRequirement: {}

hints:
  DockerRequirement:
    dockerImageId: samtools:latest

baseCommand: [/usr/local/pipeline/samtools-1.9/samtools, sort]

inputs:
  file_out_type:
    type: string
    default: 'BAM'
    inputBinding:
      position: 1
      prefix: '-O'
      separate: True
  input_file:
    type: File
    inputBinding:
      position: 4
  output_flag:
    type: string
    default: '-o'
    inputBinding:
      position: 2

arguments:
  - valueFrom: $(inputs.input_file.nameroot+'_sorted.bam')
    position: 3

outputs:
  sorted_bam:
    type: File
    outputBinding: 
      glob: $(inputs.input_file.nameroot +'_sorted.bam')
  log_file_stdout:
    type: stdout
  log_file_stderr:
    type: stderr

stdout: sam_sort_stdout.txt
stderr: sam_sort_stderr.txt