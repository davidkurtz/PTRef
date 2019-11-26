rem ptrefpkg.sql
set echo on lines 200 pages 999
@@ptrefdata.sql
spool ptrefpkg
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE ptref AS 
  PROCEDURE pthtml
  (p_recname IN VARCHAR2);

  PROCEDURE ptindex;

  PROCEDURE ptxlat
  (p_fieldname IN VARCHAR2);
END ptref;
/
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY ptref AS
----------------------------------------------------------------------------------------------------
k_amp    CONSTANT VARCHAR2(10) := '&'||'amp';
k_back   CONSTANT VARCHAR2(100) := '<a href="_ptindex.htm">index</a> <a href="javascript:javascript:history.go(-1)">back</A>';
k_copy   CONSTANT VARCHAR2(10) := '&'||'copy';
k_key    CONSTANT VARCHAR2(40) := '<img border="0" src="../static/key.gif">';
k_msg    CONSTANT VARCHAR2(200) := '(c)David Kurtz 2019, <a target="_blank" href="http://www.go-faster.co.uk">www.go-faster.co.uk</a>';
k_ptdir  CONSTANT VARCHAR2(30) := ''; --location of generated files relative to index page
k_space  CONSTANT VARCHAR2(30) := '&'||'nbsp;';
k_suffix CONSTANT VARCHAR2(10) := '.htm';
g_toolsrel VARCHAR2(20 CHAR);
----------------------------------------------------------------------------------------------------
PROCEDURE init IS
BEGIN
 SELECT toolsrel
 INTO   g_toolsrel
 FROM   psstatus;
END init;
----------------------------------------------------------------------------------------------------
PROCEDURE footer IS
BEGIN
 dbms_output.put_line('<table id="t01"><tr>');
 dbms_output.put_line('<td style="text-align:left;">'||k_back||'</td>');
 dbms_output.put_line('<td style="text-align:center;">'||k_msg||'</td>');
 dbms_output.put_line('<td style="text-align:right;">PeopleTools '||g_toolsrel||'<br><a target="_blank" href="https://github.com/davidkurtz/PTRef">PTRef<a> generated on '||TO_CHAR(sysdate)||'</td>');
 dbms_output.put_line('</tr></table>');
END footer;
----------------------------------------------------------------------------------------------------
FUNCTION ptreclink(p_recname IN VARCHAR) RETURN VARCHAR IS
  l_found INTEGER := 0;
  l_html VARCHAR2(100);
BEGIN
   SELECT 1
   INTO   l_found
   FROM   psrecdefn r
-- ,   	  psobjgroup o 
   WHERE  (r.objectownerid = 'PPT' OR r.recname = r.sqltablename)
-- AND    o.objgroupid = 'PEOPLETOOLS'
-- AND    o.entname = r.recname
   AND    r.rellangrecname = p_recname
   AND    ROWNUM=1;

  IF l_found = 1 THEN
    l_html := '<a href="'||LOWER(p_recname)||k_suffix||'">'||p_recname||'</a>';
  ELSE
    l_html := p_recname;
  END IF;
  RETURN l_html;
END ptreclink;
----------------------------------------------------------------------------------------------------
PROCEDURE tablestyle IS
BEGIN
 dbms_output.put_line('<style>');
 
 dbms_output.put_line('table, th, td { padding: 1px; border: 1px solid black; border-collapse: collapse;}');
 dbms_output.put_line('th, td { text-align: left;}');
 dbms_output.put_line('table#t01 { width:100%; border: 0px;}');
 dbms_output.put_line('table#t01 th, table#t01 td { padding: 0px; border: 0px;}');

 dbms_output.put_line('</style>');
END tablestyle;
----------------------------------------------------------------------------------------------------
PROCEDURE pthtml
(p_recname IN VARCHAR2) IS
 l_recname        VARCHAR2(15);
 l_recdescr       VARCHAR2(30);
 l_rellangrecname VARCHAR2(15);
 l_parentrecname  VARCHAR2(15);
 l_rectype        INTEGER;
 l_descrlong      CLOB;
 l_newline        BOOLEAN;
 
 l_datatype       VARCHAR2(100);
 l_col_def        VARCHAR2(1000 CHAR);

 l_key   VARCHAR2(50);

 l_counter INTEGER;
BEGIN
 init;
 
 WITH x AS (
   SELECT object_name recname
   ,      other_xml descrlong
   FROM   plan_table
   WHERE  statement_id = 'PTREF'
   AND    object_type = 'DESCR'
 )
 SELECT r.recname, r.rectype, r.recdescr, r.rellangrecname, r.parentrecname, r.descrlong||' '||x.descrlong
 INTO   l_recname, l_rectype, l_recdescr, l_rellangrecname, l_parentrecname, l_descrlong
 FROM   psrecdefn r
	LEFT OUTER JOIN x ON x.recname = r.recname
 WHERE  r.recname = UPPER(p_recname);

 dbms_output.put_line('<html><head>');
 dbms_output.put_line('<title>'||l_recname||' - '||l_recdescr||' - PeopleTools Table Reference</title>');
 dbms_output.put_line('<base target="_self">');
 tablestyle;
 dbms_output.put_line('</head><body>');

 dbms_output.put_line('<table id="t01"><tr><th><h1>'||l_recname||'</h1></th>');
 dbms_output.put_line('<th style="text-align:right;">'||k_back||'</th></tr>');
 IF l_recdescr != ' ' THEN
   dbms_output.put_line('<tr><td><h3>'||l_recdescr||'</h3></td></tr>');
 END IF;
 dbms_output.put_line('</table>');
 
 IF l_descrlong IS NOT NULL THEN
  dbms_output.put_line(l_descrlong||'<br>');
 END IF;

IF l_rectype = '1' THEN
 dbms_output.put_line('<table><tr><td>');
 FOR j IN(
  SELECT *
  FROM   pssqltextdefn t
  WHERE  sqltype = '2'
  AND    sqlid = p_recname
  AND market = 'GBL' --always for views
  AND dbtype = (
    SELECT MAX(dbtype)
    FROM   pssqltextdefn t1
    where  t1.sqlid = t.sqlid
    AND    t1.sqltype = t.sqltype
    AND    t1.market = t.market
    AND    t1.dbtype IN(' ','2')
    )
  AND effdt = (
    SELECT MAX(effdt)
    FROM   pssqltextdefn t2
    where  t2.sqlid = t.sqlid
    AND    t2.sqltype = t.sqltype
    AND    t2.market = t.market
    AND    t2.dbtype = t2.dbtype
    AND    t2.effdt <= SYSDATE
  )
  ORDER BY seqnum
 ) LOOP
   dbms_output.put_line(j.sqltext);
 END LOOP;
 dbms_output.put_line('</td><tr>');
 END IF;
 dbms_output.put_line('</table><p>');
 
 
 IF l_rellangrecname > ' ' THEN
  dbms_output.put_line('<li>Related language record: '||ptreclink(l_rellangrecname)||'</li><p>');
 ELSE 
  l_counter := 0;
  FOR j IN (
   SELECT DISTINCT r.recname, r.rectype
   FROM   psrecdefn r
-- ,   	  psobjgroup o 
   WHERE  (r.objectownerid = 'PPT' OR r.recname = r.sqltablename)
-- AND    o.objgroupid = 'PEOPLETOOLS'
-- AND    o.entname = r.recname
   AND    r.rellangrecname = l_recname 
   ORDER BY r.recname
  ) LOOP
   IF l_counter = 0 THEN
    dbms_output.put_line('<li>Related language record for');
    l_counter := 1;
   END IF;
   IF j.rectype IN(0,1) THEN
    dbms_output.put_line(' <a href="'||j.recname||k_suffix||'">'||j.recname||'</a>');  
   ELSE
    dbms_output.put_line(' '||j.recname);  
   END IF;
  END LOOP;
  IF l_counter > 0 THEN
   dbms_output.put_line('</li><p>');
  END IF;
 END IF;

 IF l_parentrecname > ' ' THEN
  SELECT rectype INTO l_rectype FROM psrecdefn WHERE recname = l_parentrecname;
  IF l_rectype = 0 THEN
   dbms_output.put_line('<li>Parent record: <a href="'
	||LOWER(l_parentrecname)||k_suffix||'">'||l_parentrecname||'</a></li><p>');
  ELSE
   dbms_output.put_line('<li>Parent record: '||l_parentrecname||'</li><p>');
  END IF;
 ELSE 
  l_counter := 0;
  FOR j IN (
   SELECT DISTINCT r.recname, r.rectype
   FROM   psrecdefn r
-- ,   	  psobjgroup o 
   WHERE  (r.objectownerid = 'PPT' OR r.recname = r.sqltablename)
-- AND    o.objgroupid = 'PEOPLETOOLS'
-- AND    o.entname = r.recname
   AND    r.parentrecname = l_recname 
   ORDER BY r.recname
  ) LOOP
   IF l_counter = 0 THEN
    dbms_output.put_line('<li>Parent record of');
    l_counter := 1;
   END IF;
   IF j.rectype = 0 THEN
    dbms_output.put_line(' <a href="'||j.recname||k_suffix||'">'||j.recname||'</a>');  
   ELSE
    dbms_output.put_line(' '||j.recname);  
   END IF;
  END LOOP;
  IF l_counter > 0 THEN
   dbms_output.put_line('</li><p>');
  END IF;
 END IF;


 dbms_output.put_line('<table>');
 dbms_output.put_line('<tr>');
 dbms_output.put_line('<th align="left">PeopleSoft Field Name</th>');
 dbms_output.put_line('<th align="left">Field Type</th>');
 dbms_output.put_line('<th align="left">Column Type</th>');
 dbms_output.put_line('<th align="left">Description</th>');
 dbms_output.put_line('</tr>');

 l_newline := FALSE;
 FOR i IN (
   WITH x AS (
     SELECT object_type
	 ,      object_name fieldname
	 ,      object_alias recname
	 ,      options
     ,      other_xml 
     FROM   plan_table
     WHERE  statement_id = 'PTREF'
     AND    object_type IN('FIELD','XLAT')
   ), ft as (
     SELECT id   fieldtype
	 ,      SUBSTR(other_xml,3) fieldtype_descr
     FROM   plan_table
     WHERE  statement_id = 'PTREF'
     AND    object_type IN('VAL')
	 AND    object_alias = 'PSDBFIELD'
	 AND    object_name = 'FIELDTYPE'
   )
   SELECT f.fieldname, f.useedit
   ,      d.fieldtype, d.descrlong, d.length, d.decimalpos
   ,      COALESCE(l1.longname,l2.longname) longname
   ,      f.edittable
   ,      f.setcntrlfld
   ,      f.defrecname, f.deffieldname
   ,      r.rectype erectype
   ,      CASE WHEN (r.objectownerid = 'PPT' OR r.recname = r.sqltablename) THEN 1 ELSE 0 END pt
   ,      NVL(x1.object_type, x2.object_type) object_type
   ,      NVL(x1.options, x2.options) options
   ,      NVL(x1.other_xml, x2.other_xml) other_xml
   ,      ft.fieldtype_descr
   FROM psrecfielddb f
        LEFT OUTER JOIN x x1 ON x1.fieldname = f.fieldname AND (x1.recname IN(f.recname,'*') OR NOT x1.recname = '-'||f.recname)
		LEFT OUTER JOIN x x2 ON x2.fieldname = f.fieldname AND 1=2
        LEFT OUTER JOIN psrecdefn r
        ON r.recname = f.edittable
	    LEFT OUTER JOIN psdbfldlabl L1
		ON l1.fieldname = f.fieldname
		AND l1.label_id = f.label_id
		LEFT OUTER JOIN psdbfldlabl L2
		ON l2.fieldname = f.fieldname
		AND l2.default_label = 1
	  , psdbfield d
	    LEFT OUTER JOIN ft 
		ON ft.fieldtype = d.fieldtype
   WHERE f.fieldname = d.fieldname
   AND   f.recname = l_recname 
   ORDER BY fieldnum
 ) LOOP
 l_col_def := '';
 dbms_output.put_line('<tr>');

 IF MOD(i.useedit,2)=1 THEN
  l_key := k_key;
 ELSE
  l_key := '';
 END IF;
 IF i.options IS NOT NULL THEN
  dbms_output.put_line('<td valign="top">'||l_key||'<a name="'||i.fieldname||'" href="'||i.options||'#'||l_recname||'">'||i.fieldname||'</a></td>');
 ELSE
  dbms_output.put_line('<td valign="top">'||l_key||'<a name="'||i.fieldname||'">'||i.fieldname||'</a></td>');
 END IF;

 --field definition processing
 l_col_def := i.fieldtype_descr;
 IF i.length>0 THEN
   l_col_def := l_col_def||'('||i.length;
   IF i.fieldtype IN (2,3) THEN
     l_col_def := l_col_def||','||i.decimalpos;
   END IF;
   l_col_def := l_col_def||')';
 END IF;
 dbms_output.put_line('<td valign="top">'||l_col_def||'</td>');

 --column definition processing 
 IF i.fieldtype = 0 THEN
  l_datatype := 'VARCHAR2';

 ELSIF i.fieldtype IN(1,8,9) THEN
  IF i.length BETWEEN 1 AND 2000 THEN
   l_datatype := 'VARCHAR2';
  ELSE
   l_datatype := 'CLOB';
  END IF;

 ELSIF i.fieldtype IN(4) THEN
  l_datatype := 'DATE';

 ELSIF i.fieldtype IN(5,6) THEN
  l_datatype := 'TIMESTAMP';

 ELSIF i.fieldtype = 2 THEN
  IF i.decimalpos > 0 THEN
   l_datatype := 'DECIMAL';
  ELSE
   IF i.length <= 4 THEN
    l_datatype := 'SMALLINT';
   ELSIF i.length > 8 THEN --20.2.2008 pt8.47??
    l_datatype := 'DECIMAL';
    i.length := i.length + 1;
   ELSE
    l_datatype := 'INTEGER';
   END IF;
  END IF;

 ELSIF i.fieldtype = 3 THEN
  l_datatype := 'DECIMAL';
  IF i.decimalpos = 0 THEN
   i.length := i.length + 1;
  END IF;

 END IF;

 l_col_def := l_datatype;

 IF l_datatype = 'VARCHAR2' THEN 
  l_col_def := l_col_def||'('||i.length||')';
 ELSIF l_datatype = 'DECIMAL' THEN
  IF i.fieldtype = 2 THEN
   l_col_def := l_col_def||'('||(i.length-1);
  ELSE /*type 3*/
   l_col_def := l_col_def||'('||(i.length-2);
  END IF;
  IF i.decimalpos > 0 THEN
   l_col_def := l_col_def||','||i.decimalpos;
  END IF;
  l_col_def := l_col_def||')';
 END IF;

 IF i.fieldtype IN(0,2,3) OR mod(FLOOR(i.useedit/256),2) = 1 THEN
  l_col_def := l_col_def||' NOT NULL';
 END IF;

 dbms_output.put_line('<td valign="top">'||l_col_def||'</td>');

 --column description processing
 dbms_output.put_line('<td valign="top">');
 IF i.descrlong IS NOT NULL  THEN
  l_col_def := RTRIM(i.descrlong);
 ELSIF i.longname IS NOT NULL THEN
  l_col_def := RTRIM(i.longname);
 END IF;
 IF i.other_xml IS NOT NULL THEN
  l_col_def := l_col_def||RTRIM(i.other_xml);
 END IF;
 IF l_col_def IS NOT NULL THEN
  dbms_output.put_line(l_col_def);
  l_newline := TRUE;
 END IF;
 
 IF i.object_type = 'XLAT' AND i.options IS NOT NULL THEN
  dbms_output.put_line('<a href="'||i.options||'">translate values</a>');
 ELSE
  
  --useeedit bit 9 set if its an xlat field, but we do not check the bit, just list the xlats
  FOR j IN (
    SELECT fieldvalue, xlatlongname, xlatshortname 
	FROM psxlatitem x 
	WHERE fieldname = i.fieldname 
    ORDER BY fieldvalue
  ) LOOP
   IF l_newline THEN
    dbms_output.put_line('<br>');
   END IF;
   dbms_output.put_line(j.fieldvalue||'='||NVL(j.xlatlongname,j.xlatshortname));
   l_newline := TRUE;
  END LOOP;

  FOR j IN (
	SELECT id, other_xml
	FROM  plan_table
	WHERE statement_id = 'PTREF'
	AND   object_type = 'VAL'
    AND   object_name = i.fieldname
	AND  (object_alias IN(p_recname,'*'))
    ORDER BY id
  ) LOOP
   IF l_newline THEN
    dbms_output.put_line('<br>');
   END IF;
   dbms_output.put_line(j.other_xml);
   l_newline := TRUE;
  END LOOP;

  IF NOT l_newline THEN
   dbms_output.put_line(k_space);
  END IF;
 END IF;

 IF BITAND(i.useedit,8192)=8192 THEN
  dbms_output.put_line('<p>Y/N Table Edit');
 END IF;
 IF BITAND(i.useedit,1048576)=1048576 THEN
  dbms_output.put_line('<p>1/0 Table Edit (1=True, 0=False)');
 END IF;
 IF i.deffieldname > ' ' THEN
  dbms_output.put_line('<p>Default: '||(CASE WHEN i.defrecname > ' ' THEN i.defrecname||'.' END)||i.deffieldname);
 END IF;

 IF i.edittable > ' ' THEN
  dbms_output.put_line('<p>Prompt Table:');
  IF i.erectype IN(0,1) AND i.pt = 1 THEN 
   dbms_output.put_line('<a href="'
	||LOWER(i.edittable)||k_suffix||'">'||i.edittable||'</a>');
   IF i.setcntrlfld > ' ' THEN
    dbms_output.put_line('<br>Set Control Field: <a href="'
	||LOWER(i.edittable)||k_suffix||'#'||i.setcntrlfld||'">'||i.setcntrlfld||'</a>');
   END IF;
  ELSE
   dbms_output.put_line(i.edittable);
   IF i.setcntrlfld > ' ' THEN
    dbms_output.put_line('<br>Set Control Field: '||i.setcntrlfld);
   END IF;
  END IF;
 END IF;
 
 dbms_output.put_line('</td>');
 dbms_output.put_line('</tr>');
 END LOOP;
 dbms_output.put_line('</table>');
 footer;
 dbms_output.put_line('</body>');
END pthtml;
----------------------------------------------------------------------------------------------------
PROCEDURE ptindex IS
BEGIN
 init;
 dbms_output.put_line('<html><head>');
 dbms_output.put_line('<title>PeopleTools Table Reference - Index</title>');
 dbms_output.put_line('<base target="_self">');
 tablestyle;
 dbms_output.put_line('</head><body><h1><a target="_blank" href="https://github.com/davidkurtz/PTRef">PTRef<a>: PeopleTools Records Reference</h1><table>');
 dbms_output.put_line('<tr><th>Tables</th><th>Views</th></tr>');
 FOR i IN (
  SELECT DISTINCT SUBSTR(r.recname,1,CASE WHEN SUBSTR(r.recname,1,2) IN('PS') THEN 3 ELSE 1 END) index_section
  FROM   psrecdefn r
--,	     psobjgroup o
  where  (r.objectownerid = 'PPT' OR r.recname = r.sqltablename)
  AND    r.rectype IN(0,1)
--AND    o.objgroupid = 'PEOPLETOOLS'
--AND    o.entname = r.recname
  ORDER BY 1
 ) LOOP

   --section heading
   dbms_output.put_line('<tr><th colspan="2"><a name="'||i.index_section||'"></a>');
   FOR j IN (
    SELECT DISTINCT SUBSTR(r.recname,1,CASE WHEN SUBSTR(r.recname,1,2) IN('PS') THEN 3 ELSE 1 END) index_section
    FROM   psrecdefn r
--,	       psobjgroup o
    where  (r.objectownerid = 'PPT' OR r.recname = r.sqltablename)
    AND    r.rectype IN(0,1)
--  AND    o.objgroupid = 'PEOPLETOOLS'
--  AND    o.entname = r.recname
    ORDER BY 1
   ) LOOP
     IF i.index_section = j.index_section THEN  
       dbms_output.put_line('<b>'||j.index_section||'</b> ');  
	 ELSE
       dbms_output.put_line('<a href="#'||j.index_section||'">'||j.index_section||'</a> ');  
     END IF;
   END LOOP;
   dbms_output.put_line('</th></tr><tr>');
   
   --section context
   FOR j IN 0..1 LOOP 
     dbms_output.put_line('<td>');
     FOR k IN (
       SELECT DISTINCT r.rectype, r.recname, r.recdescr
       FROM   psrecdefn r
       where  (r.objectownerid = 'PPT' OR r.recname = r.sqltablename)
       AND    SUBSTR(r.recname,1,CASE WHEN SUBSTR(r.recname,1,2) IN('PS') THEN 3 ELSE 1 END) = i.index_section
       AND    r.rectype = j
       ORDER BY r.recname
    ) LOOP
      dbms_output.put_line('<a name="'||k.recname||'" href="'||k_ptdir||LOWER(k.recname)||k_suffix||'">'||k.recname||'</a> - '||k.recdescr||'<br>');
    END LOOP;
    dbms_output.put_line('</td>');
   END LOOP;
   dbms_output.put_line('</tr>');
 END LOOP;
 dbms_output.put_line('</table>');
 footer;
 dbms_output.put_line('</body></html>');
 
END ptindex;
----------------------------------------------------------------------------------------------------
PROCEDURE ptxlat
(p_fieldname IN VARCHAR2) IS
 l_descrlong      CLOB;

BEGIN
 SELECT NVL(f.descrlong,l2.longname)
 INTO   l_descrlong 
 FROM   psdbfield f
 		LEFT OUTER JOIN psdbfldlabl L2
		ON l2.fieldname = f.fieldname
		AND l2.default_label = 1
WHERE  f.fieldname = p_fieldname;

 dbms_output.put_line('<html>');
 dbms_output.put_line('<head><title>'||p_fieldname||' - '||l_descrlong||' - PeopleTools XLAT Reference</title></head>');
 dbms_output.put_line('<base target="_self">');
 tablestyle;
 dbms_output.put_line('<body>');

 dbms_output.put_line('<table id="t01"><tr><th><h1>'||p_fieldname||'</h1></th>');
 dbms_output.put_line('<th style="text-align:right;">'||k_back||'</th></tr>');
 dbms_output.put_line('</table>');

 IF l_descrlong IS NOT NULL THEN
  dbms_output.put_line(l_descrlong||'<br>');
 END IF;

 dbms_output.put_line('<table>');
 dbms_output.put_line('<tr>');
 dbms_output.put_line('<th align="left">Translate Value</th>');
 dbms_output.put_line('<th align="left">Short Description</th>');
 dbms_output.put_line('<th align="left">Long Description</th>');
 dbms_output.put_line('</tr>');

 FOR i IN(
   select i.*
   from   psxlatitem i
   where  i.fieldname = p_fieldname
   AND    i.eff_status = 'A'
   AND    i.effdt = (SELECT MAX(i1.effdt)
                     FROM   psxlatitem i1
                     WHERE  i1.fieldname = p_fieldname
                     AND    i1.fieldvalue = i.fieldvalue)
   ORDER BY fieldvalue, effdt
 ) LOOP
  dbms_output.put_line('<tr>');
  dbms_output.put_line('<td valign="top">'||i.fieldvalue||'</td>');
  dbms_output.put_line('<td valign="top">'||i.xlatshortname||'</td>');
  dbms_output.put_line('<td valign="top">'||i.xlatlongname||'</td>');
  dbms_output.put_line('</tr>');
 END LOOP;

 dbms_output.put_line('</table>');
 footer;
 dbms_output.put_line('</body></html>');

END ptxlat;

END ptref;
/
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
show errors
spool off