clear screen
set serveroutput on echo off verify off feedback off trimspool on head off lines 200 termout off autotrace off
@@sql/ptrefpkg
host mkdir peopletools
set echo off 
spool index.html

execute ptref.ptindex

spool off
set echo on termout on verify on head on