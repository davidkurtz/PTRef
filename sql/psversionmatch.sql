REM psversionmatch.sql
REM (c)2022 David Kurtz, www.go-faster.co.uk 

set echo on timi on pages 99 lines 200 trimspool on LONG 50000
spool psversionmatch.lst

select * from psversion
union
select * from pslock
order by 1
/

rollback;
delete from plan_table where statement_id = 'PSVERSION';
commit;

set serveroutput on
DECLARE
  l_sql CLOB;
  l_max INTEGER;
  l_cnt INTEGER;
BEGIN
  FOR i IN (
    select t.table_name, r.recname, r.recdescr, r.descrlong
    from dba_tab_columns c
    , dba_tables t
    , sysadm.psrecdefn r
    where c.column_name = 'VERSION'
    and c.owner = 'SYSADM'
    and t.owner = c.owner
    and t.table_name = c.table_name
    and t.table_name = DECODE(r.sqltablename,' ','PS_'||r.recname,r.sqltablename)
--  and r.recname = r.sqltablename
    and not r.recname LIKE 'PS%DEL'
    order by 1
  ) LOOP
    l_sql := 'SELECT MAX(version), count(*) FROM '||i.table_name;
    dbms_output.put_line(l_sql);
    EXECUTE IMMEDIATE l_sql INTO l_max, l_cnt;
    dbms_output.put_line('max='||l_max||', cnt='||l_cnt);
    IF l_cnt > 0 THEN
      INSERT INTO plan_table 
      (statement_id, object_name, object_instance, cost, remarks, other)
      VALUES ('PSVERSION', i.table_name, l_max, l_cnt, i.recdescr, i.descrlong);
    END IF;
  END LOOP;
END;
/

column recname format a15
column table_name format a18
column recdescr format a30
column descrlong format a80
column max format 9999999
column cnt format 9999999
select object_name table_name
,      object_instance max
,      cost         cnt 
,      remarks      recdescr 
,      other        descrlong
from plan_table
where statement_id = 'PSVERSION'
order by 2,1
/

select * from psversion
union
select * from pslock
order by 2,1
/

spool off