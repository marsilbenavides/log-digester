#!/bin/bash
execDate=$(date '+%Y-%m-%d')

# check if environment variable "LOG_DIR" is set.
if [ -z "$LOG_DIR" ]; then
  echo 'Environment variable [LOG_DIR] is not set.'
  exit -1
elif [  -z "$LOG_DIR" ] && "${LOG_DIR+xxx}" = "xxx" ]; then
  echo 'Environment variable [LOG_DIR] is empty.'
  exit -1
else
  echo Using log directory: $LOG_DIR
fi

# Load digest shell
digestPath=./digest.sh
if [[ -f "$digestPath" ]]; then
  source "$digestPath"
fi

userLoginCsvFile=./userLogin.$execDate.csv
createPuOracleCsv $userLoginCsvFile

files=($LOG_DIR*)
for nextLogFile in "${files[@]}"; do
  matchPuOracle $userLoginCsvFile $nextLogFile
done
