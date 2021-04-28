#!/bin/bash

source ${CMOR_ROOT}/workflow/cmorRun1memb.sh

# initialize
login0=false
login1=false

# set active
login0=true
#login1=true

# initialize
#version=v20190920
#version=v20191108b
version=v20200218

expid=piClim-2xVOC
model=NorESM2-LM

# --- Use input arguments if exits
if [ $# -ge 1 ] 
then
     while test $# -gt 0; do
         case "$1" in
             -m=*)
                 model=$(echo $1|sed -e 's/^[^=]*=//g')
                 shift
                 ;;
             -e=*)
                 expid=$(echo $1|sed -e 's/^[^=]*=//g')
                 shift
                 ;;
             -v=*)
                 version=$(echo $1|sed -e 's/^[^=]*=//g')
                 shift
                 ;;
             * )
                 echo "ERROR: option $1 not allowed."
                 echo "*** EXITING THE SCRIPT"
                 exit 1
                 ;;
         esac
    done
fi
# --- 

echo "--------------------"
echo "EXPID: $expid       "
echo "--------------------"

echo "                    "
echo "START CMOR...       "
echo "$(date)             "
echo "                    "

if $login0
then
#----------------
# piClim-2xVOC, r1i1p1f1
#----------------
#CaseName=
years1=(0  11 21)
years2=(10 20 30)

runcmor -c=$CaseName -m=$model -e=$expid -v=$version -yrs1="${years1[*]}" -yrs2="${years2[*]}" -s=NS9560K -mpi=DMPI -s=NS9560K
#---
fi
#---

if $login1
then
#----------------
# piClim-2xVOC, r1i1p2f1
#----------------
CaseName=NF1850norbc2voc_f19_20200219
physics=2
years1=(0  11 21)
years2=(10 20 30)

runcmor -c=$CaseName -m=$model -e=$expid -v=$version -p=$physics -yrs1="${years1[*]}" -yrs2="${years2[*]}" -mpi=DMPI -s=NS2345K
#---
fi
#---


wait
echo "         "
echo "CMOR DONE"
echo "$(date)  "
echo "~~~~~~~~~"

# PrePARE QC check, create links and update sha256sum
${CMOR_ROOT}/workflow/cmorPost.sh -m=${model} -e=${expid} -v=${version} --verbose=false
