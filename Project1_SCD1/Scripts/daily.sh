#!/bin/bash

#bringing parameter file
. /home/saif/cohort_f11/env/sqp.prm

mv /home/saif/cohort_f11/datasets/Day_*.csv /home/saif/cohort_f11/datasets/Day.csv

PASSWD=`sh password.sh`
LOG_DIR=/home/saif/cohort_f11/logs/
DT=`date '+%Y-%m-%d %H:%M:%S'`
DT1=`date '+%Y%m%d'`
LOG_FILE=${LOG_DIR}/project1_daily.log

mysql --local-infile=1 -uroot -p${PASSWD} < /home/saif/cohort_f11/scripts/sql_daily.txt

if [ $? -eq 0 ]
then echo "sql insertion  and updation successfully executed at ${DT}" >> ${LOG_FILE}
else echo "sql commands failed  at ${DT} " >> ${LOG_FILE}
exit 1
fi

sqoop job --exec pro_job_imp

if [ $? -eq 0 ]
then echo "sqoop imp job successfully executed at ${DT}" >> ${LOG_FILE}
else echo "sqoop imp job failed  at ${DT} " >> ${LOG_FILE}
exit 1
fi

hive -f /home/saif/cohort_f11/scripts/hive_daily.hql

if [ $? -eq 0 ]
then echo "hive scd successfully executed at ${DT}" >> ${LOG_FILE}
else echo "hive scd job failed  at ${DT} " >> ${LOG_FILE}
exit 1
fi

sqoop job --exec pro_job_exp

if [ $? -eq 0 ]
then echo "sqoop exp job successfully executed at ${DT}" >> ${LOG_FILE}
else echo "sqoop exp job failed  at ${DT} " >> ${LOG_FILE}
exit 1
fi

mysql --local-infile=1 -uroot -p${PASSWD} < /home/saif/cohort_f11/scripts/sql_cmp.txt

if [ $? -eq 0 ]
then echo "sql comparison successfully executed at ${DT}" >> ${LOG_FILE}
else echo "sql comparison failed  at ${DT} " >> ${LOG_FILE}
exit 1
fi



mv /home/saif/cohort_f11/datasets/Day*.csv /home/saif/cohort_f11/project1_archive/Day_${DT1}.csv

if [ $? -eq 0 ]
then echo "successfully archived at ${DT}" >> ${LOG_FILE}
else echo "archival failed  at ${DT} " >> ${LOG_FILE}
exit 1
fi

echo "******************************************************************************************************" >> ${LOG_FILE}

