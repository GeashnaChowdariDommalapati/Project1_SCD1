#!bin/bash

#Sourcing the parameter file
. /home/saif/cohort_f11/env/pro_sqp_prm

PASSWD=`sh password.sh`
LOG_DIR=/home/saif/cohort_f11/logs/project1
DT=`date '+%Y-%m-%d %H:%M:%S'`
LOG_FILE=${LOG_DIR}/project1_ots.log

mysql --local-infile=1 -uroot -p${PASSWD} < /home/saif/cohort_f11/scripts/sql.txt

if [ $? -eq 0 ]
then echo "sql successfully executed at ${DT}" >> ${LOG_FILE}
else echo "sql commands failed  at ${DT} " >> ${LOG_FILE}
exit 1
fi

sqoop job --create pro_job_imp -- import \
--connect jdbc:mysql://${LOCALHOST}:${PORT_NO}/${DB_NAME}?useSSL=False \
--username ${USERNAME} --password-file ${PASSWORD_FILE} \
--query 'SELECT custid, username, quote_count, ip, entry_time, prp_1, prp_2, prp_3, ms, http_type, purchase_category, total_count, purchase_sub_category, http_info, status_code,year,month FROM customers_p2 WHERE $CONDITIONS' -m 1 \
--delete-target-dir \
--target-dir ${OP_DIR}

if [ $? -eq 0 ]
then echo "sqoop imp job successfully created at ${DT}" >> ${LOG_FILE}
else echo "sqoop imp job  failed  at ${DT} " >> ${LOG_FILE}
exit 1
fi

hive -f /home/saif/cohort_f11/scripts/hive_ots.hql

if [ $? -eq 0 ]
then echo "hive ots successfully executed at ${DT}" >> ${LOG_FILE}
else echo "sqoop hive ots  failed  at ${DT} " >> ${LOG_FILE}
exit 1
fi

sqoop job --create pro_job_exp -- export \
--connect jdbc:mysql://localhost:3306/project1?useSSL=False \
--table project1_sql_exp \
--username root --password Welcome@123 \
--direct \
--export-dir /user/hive/warehouse/project1.db/project1_sql_exp/ \
--m 1 \
-- driver com.mysql.jdbc.Driver --input-fields-terminated-by ','


if [ $? -eq 0 ]
then echo "sqoop exp job successfully created at ${DT}" >> ${LOG_FILE}
else echo "sqoop exp job  failed  at ${DT} " >> ${LOG_FILE}
exit 1
fi
