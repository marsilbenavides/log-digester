#!/bin/bash
logDir=/mnt/c/Users/1779064/.redhat/wildfly-21.0.2.Final/standalone/log/
execDate=$(date '+%Y-%m-%d')
csvFile=./userLogin.$execDate.csv
matches=(
    "Caused by: java.sql.SQLRecoverableException"
    "jboss/datasources/jdbc/PU_ORACLE"
  )
echo Log directory: $logDir

path=./digest.sh
if [[ -f "$path" ]]; then
  source "$path"
fi

createPuOracleCsv $csvFile

files=($logDir*)
for nextLogFile in "${files[@]}"; do
  matchPuOracle $csvFile $nextLogFile
done
