REM pthtml.sql
REM (c)2022 David Kurtz, www.go-faster.co.uk 

clear screen
set termout off serveroutput on 
@@sql/ptrefpkg
set lines 50 echo off verify off feedback off trimspool on head off autotrace off
host mkdir peopletools
spool _pthtml.sql
select 'set termout off echo off verify off feedback off' 
from dual
;

select 	DISTINCT 
	'spool "peopletools/'||LOWER(recname)||'.htm"'
,	'execute ptref.pthtml('''||r.recname||''');'
  FROM   psrecdefn r
--,	     psobjgroup o
  where  (r.objectownerid = 'PPT' OR r.recname = r.sqltablename)
  and    r.rectype IN(0,1)
--and    o.objgroupid = 'PEOPLETOOLS'
--and    o.entname = r.recname
--and recname = 'PSTIMEZONE'
/
select 	DISTINCT 
	'spool "peopletools/'||LOWER(f.fieldname)||'.htm"'
,	'execute ptref.ptxlat('''||f.fieldname||''');'
  FROM   psdbfield f, plan_table x
  WHERE  f.fieldname = x.object_name
  AND    x.statement_id = 'PTREF'
  AND    x.object_type = 'XLAT'
;
select 'spool off' 
from dual
;
select 'set termout on' 
from dual
;
spool off
set lines 200
@_pthtml.sql
rem del _pthtml.sql
set termout on serveroutput on echo on verify on feedback on trimspool on head on 