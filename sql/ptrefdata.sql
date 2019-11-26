REM ptrefdata.sql
set autotrace off echo on verify on feedback on
spool ptrefdata

delete from plan_table
where statement_id = 'PTREF'
/

insert into plan_table
(statement_id, object_type, object_name, other_xml)
VALUES
('PTREF','DESCR','PSVERSION','This table holds a version number for each type of cached object defined in the PeopleTools tables.  Each time an object is created, updated or deleted, both the global version number (OBJECTTYPENAME=<a href="../static/objecttypename.html#SYS">SYS</a>) and the version number that corresponds to the type of object are incremented.  The new object version number is written to the updated object.  However, if the object is deleted, a row will be written to the deleted object table (where the version number is usually a part of the unique key).  The version numbers are stored in the PeopleTools caches, and hence PeopleTools programs can determine whether the object definitions in the cache are up to date by comparing the version numbers.');

insert into plan_table(statement_id, object_type, object_name, other_xml) VALUES
('PTREF','DESCR','PSLOCK','This table is very similar to <a href="psversion.htm">PSVERSION<a>, but does not have the same OBJECTTYPE names.');

insert into plan_table(statement_id, object_type, object_name, other_xml) VALUES
('PTREF','DESCR','PSOBJGROUP','This table defines which objects are members of which security group.  Using the Object security manager, it is possible to control which developers have update and read-only access to which group.');

insert into plan_table(statement_id, object_type, object_name, other_xml) VALUES
('PTREF','DESCR','PSSQLDEFN','This record is the parent of <a href="pssqltextdefn.htm">PSSQLTEXTDEFN<a>. It holds SQL object definitions, and these objects are used widely in PeopleTools. Only rows where SQLTYPE = 2 correspond to USER_VIEWS');

--add subpages for xlat tables with at least 30 translate values
insert into plan_table (statement_id, object_type, object_name, object_alias, options)
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
SELECT 'PTREF','XLAT',y.fieldname,'*',LOWER(y.fieldname)||'.htm'
FROM y
/



insert into plan_table (statement_id, object_type, object_name, object_alias,options, other_xml) VALUES ('PTREF','FIELD','USEEDIT','*','../static/useedit.htm'
                       ,'- <a href="../static/useedit.htm">USEEDIT reference</a>');
insert into plan_table (statement_id, object_type, object_name, object_alias,options, other_xml) VALUES ('PTREF','FIELD','OBJECTTYPENAME','*','../static/objecttypename.htm'
                       ,'- <a href="../static/objecttypename.htm">Version/Table reference</a>');
insert into plan_table (statement_id, object_type, object_name, object_alias,options, other_xml) VALUES ('PTREF','FIELD','VERSION','*','../static/objecttypename.htm'
                       ,'. Internal PeopleTools version for controlling caching of object. - <a href="../static/objecttypename.htm">Version/Table reference</a>');
insert into plan_table (statement_id, object_type, object_name, object_alias,other_xml) VALUES ('PTREF','FIELD','FORMATLENGTH','*',' in characters.  Except that Images and Attachments in Kb.');
insert into plan_table (statement_id, object_type, object_name, object_alias,other_xml) VALUES ('PTREF','FIELD','IMAGE_FMT','PSDBFIELD','Only set for <a href="psdbfield.htm#FIELDTYPE">FIELDTYPE</a> of Images and Attachments.');

insert into plan_table (statement_id, object_type, object_name, object_alias, options, other_xml) VALUES ('PTREF','FIELD','DISPFMTNAME','-PSFMTITEM','psfmtitem.htm',' (see <a href="psfmtitem.htm">PSFMTITEM</a>).');
insert into plan_table (statement_id, object_type, object_name, object_alias, options, other_xml) VALUES ('PTREF','FIELD','ASCDESC','PSKEYDEFN','','<li>1 = Ascending order<br><li>0 = Descending order<br>PeopleSoft removed decending indexes in PT8.54 (due to Oracle Bug #869177 on Oracle 8i), reintroduced them in PT8.48, and finally removed them again in PT8.54.');
insert into plan_table (statement_id, object_type, object_name, object_alias, options, other_xml) VALUES ('PTREF','FIELD','RECUSE','PSRECDEFN','','. Audit Option bit values');
insert into plan_table (statement_id, object_type, object_name, object_alias, options, other_xml) VALUES ('PTREF','FIELD','AUXFLAGMASK','PSRECDEFN','',' bit values');

insert into plan_table (statement_id, object_type, object_name, object_alias, options, other_xml) VALUES ('PTREF','FIELD','OBJECTID2','*','',', as <a href="#OBJECTID1">OBJECTID1<a>');
insert into plan_table (statement_id, object_type, object_name, object_alias, options, other_xml) VALUES ('PTREF','FIELD','OBJECTID3','*','',', as <a href="#OBJECTID1">OBJECTID1<a>');
insert into plan_table (statement_id, object_type, object_name, object_alias, options, other_xml) VALUES ('PTREF','FIELD','OBJECTID4','*','',', as <a href="#OBJECTID1">OBJECTID1<a>');
insert into plan_table (statement_id, object_type, object_name, object_alias, options, other_xml) VALUES ('PTREF','FIELD','OBJECTID5','*','',', as <a href="#OBJECTID1">OBJECTID1<a>');
insert into plan_table (statement_id, object_type, object_name, object_alias, options, other_xml) VALUES ('PTREF','FIELD','OBJECTID6','*','',', as <a href="#OBJECTID1">OBJECTID1<a>');
insert into plan_table (statement_id, object_type, object_name, object_alias, options, other_xml) VALUES ('PTREF','FIELD','OBJECTID7','*','',', as <a href="#OBJECTID1">OBJECTID1<a>');

insert into plan_table (statement_id, object_type, object_name, object_alias, options, other_xml) VALUES ('PTREF','FIELD','FIELDTYPE','*','',' (from <a href="http://psst0101.wordpress.com/2008/12/03/pspnldefnfieldtype/">PSST0101<a>)');
insert into plan_table (statement_id, object_type, object_name, object_alias, options, other_xml) VALUES ('PTREF','FIELD','RECNAME_PARENT','*','','. If this comes from a sub-record, this column has the name of the sub-record, otherwise it has the same value as RECNAME.');
insert into plan_table (statement_id, object_type, object_name, object_alias, options, other_xml) VALUES ('PTREF','FIELD','SQLID','*','','. This column has different meanings depending upon value of SQLTYPE<br><li>SQLTYPE = 0: SQL object name<br><li>SQLTYPE = 1: Application Engine Step Identifier<br><li>SQLTYPE = 2: RECNAME<br><li>SQLTYPE = 6: Application Engine XSLT (XML definition)');

insert into plan_table (statement_id, object_type, object_name, object_alias, options, other_xml) VALUES ('PTREF','FIELD','SQLTYPE','*','','<br><li>0=SQL Object referenced from elsewhere<br><li>1=Application Engine Step<br><li>2=SQL View<br><li>5=Queries for DDDAUDIT and SYSAUDIT<br><li>6= Application Engine Step XSLT');

--add links to definition records
insert into plan_table (statement_id, object_type, object_name, object_alias, options, other_xml)
with x as (
select  fk.fieldname, r.recname
,	CASE WHEN r.recname LIKE 'PS%DEFN' THEN 1 ELSE 2 END pref
from    psrecdefn r
,       psrecfielddb fk
,       psrecfielddb fv
,       psrecfielddb fl
where   r.recname = r.sqltablename
and     r.rectype = 0
and     fk.recname = r.recname
and     MOD(fk.useedit,2) = 1
and     fv.recname = r.recname
and     fv.fieldname = 'VERSION'
and     fl.recname = r.recname
and     fl.fieldname = 'LASTUPDDTTM'
and exists(
        select 'x'
        from psrecfielddb f1
        where f1.recname = r.recname
        and   MOD(f1.useedit,2) = 1
        having count(*) = 1)
), y as (
select x.* 
, row_number() over (partition by fieldname order by pref, recname) seq
from x
)
select 'PTREF','FIELD',fieldname,'-'||recname,lower(recname)||'.htm'
                         ,' (see <a href="'||lower(recname)||'.htm">'||recname||'</a>).'
from y where seq = 1
/



insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSDBFIELD',0,'0=Character');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSDBFIELD',1,'1=Long Character');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSDBFIELD',2,'2=Number'); 
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSDBFIELD',3,'3=Signed Number'); 
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSDBFIELD',4,'4=Date'); 
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSDBFIELD',5,'5=Time'); 
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSDBFIELD',6,'6=DateTime');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSDBFIELD',8,'8=Image / Attachment');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSDBFIELD',9,'9=Image Reference');

insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FORMAT','*',0,'0=<li>If Fieldtype=0 (Character) then Upper Case<li>If Fieldtype=6 (DateTime) then HH:MM');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FORMAT','*',1,'1=Name');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FORMAT','*',2,'2=Phone Number North American (mandatory length 12 characters)');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FORMAT','*',3,'3=Zip/Postal Code North American (mandatory length 10 characters)');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FORMAT','*',4,'4=US Social Security Number (mandatory length 9 characters)');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FORMAT','*',5,'5=');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FORMAT','*',6,'6=Mixed Case');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FORMAT','*',7,'7=Raw/Binary');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FORMAT','*',8,'8=Numbers only');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FORMAT','*',9,'9=SIN (mandatory length 9 characters)');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FORMAT','*',10,'10=International Phone Number');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FORMAT','*',11,'11=Zip/Postal Code International');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FORMAT','*',12,'12=Time HH:MM:SS');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FORMAT','*',13,'13=Time HH:MM:SS.999999');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FORMAT','*',14,'14=Custom (<a href="#FORMATFAMILY">FORMATFAMILY</a> and <a href="#DISPFMTNAME">DISPFMTNAME</a> must be completed)');

insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','IMAGE_FMT','*',1,'1=BMP - Bitmaps');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','IMAGE_FMT','*',2,'2=CUT - HALO Image');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','IMAGE_FMT','*',3,'3=DIB - Bitmaps');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','IMAGE_FMT','*',4,'4=EPS - Postscript');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','IMAGE_FMT','*',5,'5=GIF - Graphics Int Format');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','IMAGE_FMT','*',6,'6=JPG - JPEG');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','IMAGE_FMT','*',7,'7=PCT - Macintosh');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','IMAGE_FMT','*',8,'8=PCX - Zsoft');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','IMAGE_FMT','*',9,'9=RLE - Bitmaps');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','IMAGE_FMT','*',10,'10=TGA - Targa');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','IMAGE_FMT','*',16,'16=Attachment');

insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','OBJECTID1','*',1,'1=Record');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','OBJECTID1','*',2,'2=Field');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','OBJECTID1','*',3,'3=Menu');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','OBJECTID1','*',4,'4=Bar Name');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','OBJECTID1','*',5,'5=Item Name');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','OBJECTID1','*',9,'9=Page');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','OBJECTID1','*',10,'10=Component');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','OBJECTID1','*',12,'12=Event');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','OBJECTID1','*',20,'20=Database Type');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','OBJECTID1','*',21,'21=Effective Date');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','OBJECTID1','*',39,'39=Market');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','OBJECTID1','*',60,'60=Message');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','OBJECTID1','*',66,'66=Application Engine Program');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','OBJECTID1','*',74,'74=Component Interface');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','OBJECTID1','*',77,'77=Section');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','OBJECTID1','*',78,'78=Step');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','OBJECTID1','*',87,'87=Subscription');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','OBJECTID1','*',104,'104=Application Package');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','OBJECTID1','*',105,'105=Class');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','OBJECTID1','*',106,'106=Class');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','OBJECTID1','*',107,'107=Class');

insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',0,'00=Core');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',10,'10=Education and Government');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',18,'18=Service Industries');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',19,'19=Comm., Transportation &'||' Util');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',20,'20=Retail');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',21,'21=Performance Measurement');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',22,'22=HealthCare');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',23,'23=Student Administration');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',25,'25=U.S. Federal Govt');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',26,'26=Canadian Govt');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',30,'30=Intl Translations');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',32,'32=Netherlands');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',33,'33=United Kingdom');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',34,'34=Espanol/Spain');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',35,'35=France');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',36,'36=Portuguese');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',37,'37=Italy');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',39,'39=German');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',50,'50=South Africa');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',60,'60=Latin America Local');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',61,'61=Mexico');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',62,'62=Argentina');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',63,'63=Brazil');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',81,'81=Japanese');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',88,'88=Asia/Pacific');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RELEASELABEL','*',99,'99=PeopleSoft Select');


insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',1,'1=Frame');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',2,'2=Group Box');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',3,'3=Static Image');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',4,'4=Edit Box');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',5,'5=Drop Down List');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',6,'6=Long Edit Box');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',7,'7=Check Box');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',8,'8=Radio Button');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',9,'9=Image');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',10,'10=Scroll Bar');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',11,'11=Subpage');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',12,'12=Push Button/Link - PeopleCode');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',13,'13=Push Button/Link - Scroll Action');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',14,'14=Push Button/Link - Toolbar Action');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',15,'15=Push Button/Link - External Link');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',16,'16=Push Button/Link - Internal Link');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',17,'17=Push Button/Link - Process');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',18,'18=SecPage ');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',19,'19=Grid');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',20,'20=Tree');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',21,'21=Push Button/Link - Secondary Page');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',23,'22=Horizontal Rule');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',24,'24=Tab Separator');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',25,'25=HTML Area');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',26,'26=Push Button/Link - Prompt Action');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',27,'27=Scroll Area');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',29,'29=Push Button/Link - Page Anchor');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',30,'30=Chart');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',31,'31=Push Button/Link - Instant Message Action');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','FIELDTYPE','PSPNLFIELD',32,'32=Analytic Grid');

insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RECTYPE','*',0,'0=SQL Table');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RECTYPE','*',1,'1=SQL View');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RECTYPE','*',2,'2=Derived Work/Record');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RECTYPE','*',3,'3=Subrecord');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RECTYPE','*',5,'5=Dynamic View');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RECTYPE','*',6,'6=Query View');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RECTYPE','*',7,'7=Temporary Table');

insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RECUSE','PSRECDEFN',1,'1=Add');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RECUSE','PSRECDEFN',2,'2=Change');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RECUSE','PSRECDEFN',4,'4=Delete');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','RECUSE','PSRECDEFN',8,'8=Selective');

insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','AUXFLAGMASK','PSRECDEFN',16,'65536=Tools Table');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','AUXFLAGMASK','PSRECDEFN',17,'131072=Managed Tools Table');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','AUXFLAGMASK','PSRECDEFN',18,'262144=In use, but not yet sure what it does!');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','AUXFLAGMASK','PSRECDEFN',19,'524288=Server -> User (Down Sync)');
insert into plan_table (statement_id, object_type, object_name, object_alias, id, other_xml) VALUES ('PTREF','VAL','AUXFLAGMASK','PSRECDEFN',20,'1048576=User -> Server (Up Sync)');

commit;

set wrap on long 1000
column statement_id format a8
column object_type format a8
column obect_alias formata 20
column options format a40
select statement_id, object_type, object_name, object_alias, options, other_xml
from plan_table
order by 1,2,3,4
/

spool off
