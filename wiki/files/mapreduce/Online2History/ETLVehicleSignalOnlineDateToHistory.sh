#!/bin/sh

bin=`dirname "$0"`
bin=`cd "$bin">/dev/null; pwd`
ETL_HOME=$bin/..
ETL_HOME=`cd "$ETL_HOME">/dev/null; pwd`


if [ $# -ne 1 ] ; then
   echo "Miss ETL Time Paramater,Format is [YYYY-MM-DD]"
else
   /opt/hadoop/bin/hadoop jar timasync.provider.GaeiEV.mapreduce-\>1.0-SNAPSHOT-job.jar ETLVehicleSignalOnlineDateToHistoryData_v3 $1
fi



