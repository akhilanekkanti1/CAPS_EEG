#!/bin/bash
#--------------------------------------------------------------
# This script:
#	* Creates a batch job for $SUB
#	* Batch jobs are saved to the path defined in MATLAB script
#	* Executes batch job
#
#
#--------------------------------------------------------------

# set options and load matlab
SINGLECOREMATLAB=true
ADDITIONALOPTIONS=""

if "$SINGLECOREMATLAB"; then
 ADDITIONALOPTIONS="-singleCompThread"
fi

# create and execute job
echo "${SUB}"
echo "Running ${SCRIPT}"

module load matlab
matlab -nosplash -nodisplay -nodesktop ${ADDITIONALOPTIONS} -r "clear; addpath('$EEGLAB_PATH'); sub='$SUB'; script_file='$SCRIPT'; run('preprocess_ct.m'); exit"