#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/usr/local/pipeline/FastQC/fastqc] 
requirements:
  InitialWorkDirRequirement:
    listing:
     - $(inputs.fastq_file)
  InlineJavascriptRequirement: {}

hints:
  DockerRequirement:
    dockerImageId: fastqc:latest
inputs:
  fastq_file:
    type: File
    inputBinding:
      valueFrom: $(self.basename)
      position: 1
outputs:
  forward_html_file:
    type: File
    outputBinding:
      glob: $(inputs.fastq_file.nameroot.split(".fastq")[0] + '_fastqc' + '.html')
  forward_zip_file:
    type: File
    outputBinding:
      glob: $(inputs.fastq_file.nameroot.split(".fastq")[0] + '_fastqc' + '.zip')
  log_file_stdout:
    type: stdout
  log_file_stderr:
    type: stderr
stdout: fastqc_stdout.txt
stderr: fastqc_stderr.txt