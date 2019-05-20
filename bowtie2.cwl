#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  InitialWorkDirRequirement:
    listing:
      - $(inputs.forward)
      - $(inputs.bowtie2_ref_1)
      - $(inputs.bowtie2_ref_2)
      - $(inputs.bowtie2_ref_3)
      - $(inputs.bowtie2_ref_4)
      - $(inputs.bowtie2_ref_rev_1)
      - $(inputs.bowtie2_ref_rev_2)                  
  InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerImageId: bowtie2:latest

baseCommand: [bowtie2]
inputs:
  ref_name:
    type: string
    default: 'human_bowtie_index'
    inputBinding:
      position: 1
      prefix: '-x'
      separate: True
  forward:
    type: File
    inputBinding:
      valueFrom: $(self.basename)
      position: 2
      prefix: '-U'
      separate: True

  #secondary files
  bowtie2_ref_1:
    type: File
  bowtie2_ref_2:
    type: File
  bowtie2_ref_3:
    type: File
  bowtie2_ref_4:
    type: File
  bowtie2_ref_rev_1:
    type: File
  bowtie2_ref_rev_2:
    type: File   

arguments:
  - valueFrom: $(inputs.forward.nameroot.split("_")[0] + '.sam')
    position: 3
    prefix: '-S'
    separate: True
outputs:
  aligned_sam:
    type: File
    outputBinding: 
      glob: $(inputs.forward.nameroot.split("_")[0] + '.sam')
  log_file_stdout:
    type: stdout
  log_file_stderr:
    type: stderr

stdout: bowtie2_stdout.txt
stderr: bowtie2_stderr.txt