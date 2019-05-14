#! usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  InitialWorkDirRequirement:
    listing:
     - $(inputs.bam_file)
  InlineJavascriptRequirement: {}
  ShellCommandRequirement:
    class:

hints:
  DockerRequirement:
    dockerImageId: samtools:latest

baseCommand: [/usr/local/pipeline/samtools-1.9/samtools, sort]

inputs:
  file_out_flag:
    type: string
    default: '-O'
    inputBinding:
      position: 1
  file_out_type:
    type: string
    default: 'BAM'
    inputBinding:
      position: 2
  bam_file:
    type: File
    inputBinding:
      position: 5
  output_flag:
    type: string
    default: '-o'
    inputBinding:
      position: 3

arguments:
  - valueFrom: $(inputs.bam_file.nameroot+'_sorted'+'.bam')
    position: 4

outputs:
  sorted_bam:
    type: File
    outputBinding: 
      glob: $(inputs.bam_file.nameroot +'_sorted.bam')
  log_file_stdout:
    type: stdout
  log_file_stderr:
    type: stderr

stdout: sam_sort_stdout.txt
stderr: sam_sort_stderr.txt