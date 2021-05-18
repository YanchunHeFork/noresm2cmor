#!/bin/bash

source ${CMOR_ROOT}/workflow/cmorRun1memb.sh

# initialize
login0=false
login1=false

# set active
#login0=true
login1=true

# initialize
#version=v20190920
#version=v20191108b
#version=v20200206
#version=v20200218
version=v20200702b

expid=amip
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
#CaseName=NFHISTnorpddmsbc_f19_mg17_20190807
years1=(1979 $(seq 1980 10 2000) 2010)
years2=(1979 $(seq 1989 10 2009) 2014)

runcmor -c=$CaseName -m=$model -e=$expid -v=$version -yrs1="${years1[*]}" -yrs2="${years2[*]}" -mpi=DMPI
#---
fi
#---

if $login1
then
CaseName=NFHISTnorpddmsbc_f19_mg17_20191025
physics=2
years1=(1979 $(seq 1980 10 2000) 2010)
years2=(1979 $(seq 1989 10 2009) 2014)

runcmor -c=$CaseName -m=$model -e=$expid -v=$version -p=$physics -yrs1="${years1[*]}" -yrs2="${years2[*]}" -mpi=DMPI
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
