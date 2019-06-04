clear screen
set serveroutput on echo off verify off feedback off trimspool on head off lines 200

host mkdir peopletools
spool peopletools\_ptindex.html

execute ptref.ptindex

spool off