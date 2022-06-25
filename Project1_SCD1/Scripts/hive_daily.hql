use project1;

truncate table day;

truncate table temp;

set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.dynamic.partition=true;

load data inpath '/user/saif/project/day/' into table day;

insert overwrite table temp select d.custid, d.username, d.quote_count, d.ip, d.entry_time, d.prp_1, d.prp_2, d.prp_3, d.ms, d.http_type, d.purchase_category, d.total_count, d.purchase_sub_category, d.http_info, d.status_code, current_date(), d.year_col, d.month_col
from scd_tgt st full outer join day d on st.custid = d.custid where d.custid is not null; 

insert into temp select st.custid, st.username, st.quote_count, st.ip, st.entry_time, st.prp_1, st.prp_2, st.prp_3, st.ms, st.http_type, st.purchase_category, st.total_count, st.purchase_sub_category, st.http_info, st.status_code, st.date_col, st.year_col, st.month_col
from scd_tgt st full outer join day d on st.custid = d.custid where d.custid is null; 

insert overwrite table scd_tgt partition(year_col,month_col) select custid, username, quote_count, ip, entry_time, prp_1, prp_2, prp_3, ms, http_type, purchase_category, total_count, purchase_sub_category, http_info, status_code, date_col, year_col, month_col from temp;

insert overwrite table project1_sql_exp select custid, username, quote_count, ip, entry_time, prp_1, prp_2, prp_3, ms, http_type, purchase_category, total_count, purchase_sub_category, http_info, status_code,year_col, month_col from scd_tgt where date_col=current_date();

