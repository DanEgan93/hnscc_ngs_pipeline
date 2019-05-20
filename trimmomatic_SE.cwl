#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  InitialWorkDirRequirement:
    listing:
     - $(inputs.fastq_file)
     - $(inputs.adapter_clip)
  InlineJavascriptRequirement: {}

hints:
  DockerRequirement:
    dockerImageId: trimmomatic:latest

baseCommand: [java, -jar, /usr/local/pipeline/Trimmomatic-0.38/trimmomatic-0.38.jar, SE, -phred33]

inputs:
  fastq_file:
    type: File
    inputBinding:
      valueFrom: $(self.basename)
      position: 1
  adapter_clip:
    type: File
    inputBinding:
      valueFrom: $(self.path+':0:95:95')
      prefix: 'ILLUMINACLIP:'
      separate: False
      position: 3
  crop_def:
    type: string
    default: '150'
    inputBinding:
      prefix: 'CROP:'
      separate: False
      position: 4
  sliding_window:
    type: string
    default: '4:20'
    inputBinding:
      prefix: 'SLIDINGWINDOW:'
      separate: False
      position: 5
  minlen:
    type: string
    default: '40'
    inputBinding:
      prefix: 'MINLEN:'
      separate: False
      position: 6

arguments:
  - valueFrom: $(inputs.fastq_file.nameroot.split('.fastq')[0]+'.qfilter.fastq.gz')
    position: 2


outputs:
  forward_q_filter_file:
    type: File
    outputBinding: 
      glob: $(inputs.fastq_file.nameroot.split('.fastq')[0] + '.qfilter.fastq.gz')
  log_file_stdout:
    type: stdout
  log_file_stderr:
    type: stderr

stdout: trimmomatic_stdout.txt
stderr: trimmomatic_stderr.txt 