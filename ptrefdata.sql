REM ptrefdata.sql
set autotrace off
spool ptrefdata

delete from plan_table
where statement_id = 'PTREF'
/

insert into plan_table
(statement_id, object_type, object_name, other_xml)
VALUES
('PTREF','DESCR','PSVERSION','This table holds a version number for each type of cached object defined in the PeopleTools tables.  Each time an object is created, updated or deleted, both the global version number (<href="#OBJECTNAME">OBJECTTYPENAME</a>=SYS) and the version number that corresponds to the type of object are incremented.  The new object version number is written to the updated object.  However, if the object is deleted, a row will be written to the deleted object table (where the version number is usually a part of the unique key).  The version numbers are stored in the PeopleTools caches, and hence PeopleTools programs can determine whether the object definitions in the cache are up to date by comparing the version numbers.');

insert into plan_table
(statement_id, object_type, object_name, other_xml)
VALUES
('PTREF','FIELD','OBJECTTYPENAME','../static/objecttypename.html');

insert into plan_table
(statement_id, object_type, object_name, other_xml)
VALUES
('PTREF','FIELD','VERSION','../static/objecttypename.html');

insert into plan_table (statement_id, object_type, object_name, other_xml)
with x as (
select 	 r.recname, f.fieldname, count(*) num_values
  FROM   psrecdefn r, psrecfielddb f, psxlatitem i
  where  (r.objectownerid = 'PPT' OR r.recname = r.sqltablename)
  and    r.rectype IN(0,1)
  and    r.recname = f.recname
  and    i.fieldname = f.fieldname
  group by r.recname, f.fieldname
), y as (
select DISTINCT fieldname, num_values
from x
where num_values >= 30
)
SELECT 'PTREF','XLAT',y.fieldname,LOWER(y.fieldname)||'.html'
FROM y
/

--insert into plan_table (statement_id, object_type, object_name, other_xml) VALUES ('PTREF','XLAT','OBJECTOWNERID','objectownerid.html');
--insert into plan_table (statement_id, object_type, object_name, other_xml) VALUES ('PTREF','XLAT','ECFILEROWID','ecfilerowid.html');
--insert into plan_table (statement_id, object_type, object_name, other_xml) VALUES ('PTREF','XLAT','LANGUAGE_CD','language_cd.html');
--insert into plan_table (statement_id, object_type, object_name, other_xml) VALUES ('PTREF','XLAT','MARKET','market.html'); 

commit;

select statement_id, object_type, object_name, other_xml
from plan_table
/

spool off
