create database if not exists project1;
use project1;

create table if not exists day(
custid int,
username string,
quote_count string,
ip string,
entry_time string,
prp_1 string,
prp_2 string,
prp_3 string,
ms string,
http_type string,
purchase_category string,
total_count string,
purchase_sub_category string,
http_info string,
status_code int,
year_col int,
month_col int 
)
row format delimited fields terminated by ',';

create table if not exists temp(
custid int,
username string,
quote_count string,
ip string,
entry_time string,
prp_1 string,
prp_2 string,
prp_3 string,
ms string,
http_type string,
purchase_category string,
total_count string,
purchase_sub_category string,
http_info string,
status_code int,
date_col date,
year_col int,
month_col int
)
row format delimited fields terminated by ',';

set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.dynamic.partition=true;

create table if not exists scd_tgt(
custid int,
username string,
quote_count string,
ip string,
entry_time string,
prp_1 string,
prp_2 string,
prp_3 string,
ms string,
http_type string,
purchase_category string,
total_count string,
purchase_sub_category string,
http_info string,
status_code int,
date_col date 
)
partitioned by (year_col int,month_col int)
row format delimited fields terminated by ',';

create table if not exists project1_sql_exp(
custid int,
username string,
quote_count string,
ip string,
entry_time string,
prp_1 string,
prp_2 string,
prp_3 string,
ms string,
http_type string,
purchase_category string,
total_count string,
purchase_sub_category string,
http_info string,
status_code int,
year_col int,
month_col int 
)
row format delimited fields terminated by ',';

