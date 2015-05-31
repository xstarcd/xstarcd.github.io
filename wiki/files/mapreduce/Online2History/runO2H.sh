#!/bin/sh
#runO2H.sh
# Create: 2013-03-11
# Update: 2013-03-11
# /etc/crontab
#30 0 * * * admin /opt/mapreduce/Online2History/runO2H.sh YESTERDAY CRON
  
JARPRG=timasync.provider.GaeiEV.mapreduce1.0-job_Online2History_20130311.jar
HADOOP=/opt/hadoop/bin/hadoop
LOGPATH=/var/log/mapreduce
delcycle=30
tempfiles='/user/admin/GaeiEV70_VehicleConditionSignalData_History* /user/admin/user/admin/partitions_*'
  
export PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin
USAGE(){
    echo Usage:
    echo "$0 2013-02-26"
    echo "$0 'YESTERDAY'" "CRON"
    echo "$0 -h"
}
z_clearcycle(){
    find "${1}" -maxdepth 1 -type f -atime +${2} -exec rm -rf {} \;
    if [ "$?" = "0" ];then
        echo "${2} days ago a successful clean-up of spare parts for ${1}'s paper!"
    fi
}
SHELLPATH=`cd $(dirname $0) >/dev/null; pwd`
LOGFILE="$LOGPATH/Online2History_`date +%Y%m%d`.log"
touch "$LOGFILE" >/dev/null 2>&1
[ "$?" != "0" ] && echo "Error:$LOGFILE Permission denied!" && exit 1
  
if [ "$2" = "CRON" ];then
    exec 1>>"$LOGFILE"
    exec 2>&1
fi
  
DAY=$1
[ -z "$DAY" -o "$DAY" = "-h" ] && USAGE && exit 1
[ "$DAY" = 'YESTERDAY' ] &&  DAY=`date +%Y-%m-%d -d '-1 day'`
DAY=`date -d "$DAY" +%Y-%m-%d 2>/dev/null`
[ "$?" != "0" ] && echo "Error:Date format error!" && exit 1
cd "$SHELLPATH" > /dev/null
[ ! -f "$JARPRG" ] && echo "Error:$JARPRG not exist!" && exit 1
 
START=`date +"%Y-%m-%d %H:%M:%S"`
echo "START remove old temp file on hdfs at $START"
for tempf in $tempfiles;do
    echo "$HADOOP" fs -rmr $tempf
    "$HADOOP" fs -rmr $tempf
done
echo "START:$START - END:`date +'%Y-%m-%d %H:%M:%S'`(rm old temp file)"
 
START=`date +"%Y-%m-%d %H:%M:%S"`
echo "START online > history at $START,DAY=$DAY"
"$HADOOP" jar "$JARPRG" ETLVehicleSignalOnlineDateToHistoryData $DAY
RET_V=$?
[ "$RET_V" != "0" ] && echo "Errot:jar runtime error!"
echo "START:$START - END:`date +'%Y-%m-%d %H:%M:%S'`(Oline2History)"
 
z_clearcycle "$LOGPATH" "$delcycle"
exit $RET_V
