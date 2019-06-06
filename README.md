# PTRef
This utility extracts information about the PeopleTools tables in a PeopleSoft database to a set of HTML files that can be navigated via a browser.

Like many other PeopleSoft professionals, I spend a lot of time look at the PeopleTools tables.  In general, these tables contain meta-data about the PeopleSoft application.  Much of the application is stored in PeopleTools tables. Some provide information about the Data Model.   Many of my utility scripts reference the PeopleTools tables.  Thus, it is very helpful to be able to understand what is in these tables.
In PeopleSoft for the Oracle DBA I discussed some tables that are of regular interest.  I included the tables that correspond to the database catalogue, and that are used during the PeopleSoft login procedure.  The tables that are maintained by the process scheduler are valuable because they contain information about who ran what process when, and how long they ran.

I am not the only person to have started to document the PeopleTools tables on their website or blog, most people have picked a few tables that are of particular interest.  However, I want to tackle the problem in a slightly different way.  There are over 3000 PeopleTools tables and view.  It is simply not viable to do even a significant number of them manually.   So, I have written some SQL and PL/SQL to dynamically generate a page for each PeopleTools table and view, and I have put as much information about these records as I can find in the PeopleTools tables themselves, augmented with some additional data of my own.  Reference to other objects appear as link to those pages. 

The utility is mostly written as a PL/SQL package.  It should be installed into the PeopleSoft owner ID schema (usually SYSADM).  It does not require any additional tables.  Oracle's plan table is used as a temporary working storage table to hold additional metadata.

Instructions:

1. Unzip the the file from github and navigate to the root directory.
2. Open SQL*Plus and connect as SYSADM
3. Run ptindex.html to generate the index page (this will also install package and load addition data)
4. Run pthtml.sql to generate the package for each record
5. The index.html page will be generated in the current directory.  The pages for each record will be in the PeopleTools directory.  
6. Open the reference with you  browser starting with index.html

David Kurtz