#! usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  InitialWorkDirRequirement:
    listing:
     - $(inputs.sorted_bam_file)
  InlineJavascriptRequirement: {}
  ShellCommandRequirement:
    class: string

hints:
  DockerRequirement:
    dockerImageId: samtools:latest

baseCommand: [/usr/local/pipeline/samtools-1.9/samtools, index]

inputs:
  sorted_bam_file:
    type: File
    inputBinding:
      position: 1

outputs:
  indexed_bam:
    type: File
    outputBinding: 
      glob: $(inputs.sorted_bam_file.basename + '.bai') 
  log_file_stdout:
    type: stdout
  log_file_stderr:
    type: stderr

stdout: sam_index_stdout.txt
stderr: sam_index_stderr.txt