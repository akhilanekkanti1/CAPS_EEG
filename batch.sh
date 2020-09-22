#!/bin/bash
#--------------------------------------------------------------
# This script executes $SHELL_SCRIPT for $SUB and matlab $SCRIPT	
# Akhila Nekkanti 2020.09.14
#--------------------------------------------------------------
## Set your study
STUDY=EEG
# Set subject list
SUBJLIST=`cat subj_list1.txt`
# EEGLAB Path
EEGLAB_PATH=/projects/fabblab/shared/matlab/eeglab/
# Set scripts directory path
#SCRIPTS_DIR=/projects/fabblab/shared/EEG/scripts
# Set MATLAB script path
SCRIPT=/projects/fabblab/shared/EEG/scripts/preprocess_ct.m
# Set shell script to execute
SHELL_SCRIPT=preprocess_job.sh
# RRV the results files
RESULTS_INFIX=preprocess_ct
# Set output dir 
OUTPUTDIR=projects/fabblab/shared/EEG/output/
# Set job parameters
cpuspertask=1
mempercpu=8G
# Create and execute batch job
for SUB in $SUBJLIST; do
	sbatch --export ALL,SCRIPT=$SCRIPT,SUB=$SUB,EEGLAB_PATH=$EEGLAB_PATH,  \
		--job-name=${RESULTS_INFIX} \
		-o ${OUTPUTDIR}/${SUB}_${RESULTS_INFIX}.log \
		--cpus-per-task=${cpuspertask} \
	 	--mem-per-cpu=${mempercpu} \
		--partition=ctn \
		--account=fabblab \
		${SHELL_SCRIPT}
	sleep .25
done

