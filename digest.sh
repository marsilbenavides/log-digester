#!/bin/bash
createPuOracleCsv() {
  local csvFile=$1
  if [ -f "$csvFile" ]
    then
      echo File $csvFile exists.
      # TODO Pending what to do.
  fi

  # Write headers
  echo 'FILENAME, LINE NUMBER, LOG DATE, LOG TIME, TEXT' > $csvFile
}

matchPuOracle() {
  local match="jboss/datasources/jdbc/PU_ORACLE"
  local csvFile=$1
  local logFile=$2
  local allText=$(cat $logFile)
  echo Looking for \'$match\' within log file \'$logFile\'
  local matchLineNumbers=( $(echo "$allText" | grep -n $match | cut -d : -f 1) )
  echo -e '\tTotal matches: '${#matchLineNumbers[@]}
  
  for nextMatchLN in ${matchLineNumbers[@]}; do
    local lineText=$(echo "$allText" | sed -n $nextMatchLN'p;' | tr -d '\n' | tr -d '\r')

    local logDate=${lineText:0:10}
    local logTime=${lineText:11:8}

    # Add new entry to csv files. Beware: don't use spaces.
    echo \"$logFile\",$nextMatchLN,$logDate,$logTime,\"$lineText\" >> $csvFile
  done
}
